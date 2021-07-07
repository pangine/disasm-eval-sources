package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	utils "github.com/pangine/disasm-eval-sources/disasm-eval-generate/utils"
)

// rootDir uses `go list` to locate the present package
func rootDir() (dir string) {
	golist := exec.Command("go", "list", "-f", "{{.Dir}}", "github.com/pangine/disasm-eval-sources/disasm-eval-generate")
	res, errin := golist.Output()
	if errin != nil {
		fmt.Println("ERROR: Cannot find the go project, please install this project using `go get` or specify the location of the project using \"-pth\" argument.")
		panic(errin)
	}
	dir = string(res)
	return filepath.Join(dir, "..")
}

// escapeString is a go version of src/linux_scripts/file_name_escape.awk
func escapeString(instr, escChar string) (outStr string) {
	for _, c := range instr {
		if (c >= '0' && c <= '9') ||
			(c >= 'A' && c <= 'Z') ||
			(c >= 'a' && c <= 'z') {
			outStr += string(c)
		} else {
			outStr += fmt.Sprintf(escChar+"%02x", c)
		}
	}
	return
}

func main() {
	archFlag := flag.String("arch", "x86_64-pc", "Arch of compilation (i.e. x86_64-pc [default])")
	sysFlag := flag.String("sys", "linux", "Compiling system (i.e. linux [default])")
	cplFlag := flag.String("cpl", "gnu-gcc-7.5.0", "Compiler with target exec format and version (i.e. gnu-clang-3.8.0)")
	objFlag := flag.String("obj", "", "Compilation target object type (i.e. gnu-elf). By default, it will be generated using the compiler type.")
	pkgFlag := flag.String("pkg", "", "package name and version for compliation (i.e. openssh-7.1p2). Mandatory.")
	optFlag := flag.String("opt", "", "The options that should be used in compilation (i.e. -O2)")
	pthFlag := flag.String("pth", "", "The path to the the root dir of this project. Mandatory if it is not in your go path.")
	outFlag := flag.String("out", ".", "The path to the output directory. By default it will be the current directory")
	clnFlag := flag.Bool("clean", false, "Whether to clean the generated docker images after build. By default it is false if not specified.")
	rcrFlag := flag.Bool("recreate", false, "Whether to create the docker images if it already exits. By default it is false if not specified.")
	iccKFlag := flag.String("icc_key", "NULL", "serial key for icc installation.")
	forceFlag := flag.String("frc", "", "Force to run an unsupported compiler and speicify the docker image to use (i.e. ubuntu:18.04).")

	flag.Parse()
	arch := *archFlag
	sys := *sysFlag
	cpl := *cplFlag
	obj := *objFlag
	pkg := *pkgFlag
	opt := *optFlag
	pth := *pthFlag
	out := *outFlag
	cln := *clnFlag
	rcr := *rcrFlag
	iccKey := *iccKFlag
	force := *forceFlag

	if pkg == "" {
		fmt.Println("You must specify a package name to compile")
		os.Exit(1)
	}

	if pth == "" {
		pth = rootDir()
	}
	var err error
	pth, err = filepath.Abs(pth)
	if err != nil {
		fmt.Printf("ERROR: Input path directory cannot be evaled: %s\n", *pthFlag)
		panic(err)
	}

	out, err = filepath.Abs(out)
	if err != nil {
		fmt.Printf("ERROR: Input output directory cannot be evaled: %s\n", *outFlag)
		panic(err)
	}

	// Generate required path and tag names
	if obj == "" {
		CplLst := strings.Split(cpl, "-")
		if len(CplLst) == 0 {
			fmt.Printf("ERROR: Input compiler invalid: %s\n", cpl)
			os.Exit(1)
		}
		switch CplLst[0] {
		case "gnu":
			obj = "gnu-elf"
		case "msvc":
			obj = "msvc-coff"
		}
	}

	pathSys := filepath.Join(pth, "images", arch, sys)
	pathTpl := filepath.Join(pathSys, cpl)
	pathPkg := filepath.Join(pathTpl, pkg)
	if _, err := os.Stat(pathPkg); os.IsNotExist(err) {
		fmt.Printf("ERROR: File path generated according to input does not exist: %s\n", pathPkg)
		os.Exit(1)
	}

	cplStz := strings.ReplaceAll(cpl, "+", "p")

	imgTpl := fmt.Sprintf("pangine-data/%s/%s/%s", arch, sys, cplStz)
	imgPkg := fmt.Sprintf("%s/%s", imgTpl, pkg)
	optFld := escapeString(opt, "_")
	ctnName := fmt.Sprintf("pangine-data-%s-%s-%s-%s-%s", arch, sys, cplStz, pkg, optFld)

	var distro string
	var ok bool
	if distro, ok = utils.CplToDistroMap[cpl]; !ok && force == "" {
		fmt.Printf("ERROR: Unsupported compiler: %s\n", cpl)
		os.Exit(1)
	}

	if force != "" {
		distro = force
	}

	escDistro := strings.ReplaceAll(distro, ":", "-")
	escDistro = strings.ReplaceAll(escDistro, "/", "-")
	sysTpl := fmt.Sprintf("%s-%s-%s-%s", arch, sys, obj, escDistro)

	ctnUser := "ubuntu"
	ctnHome := filepath.Join("/home", ctnUser)
	ctnOut := filepath.Join(ctnHome, "output")
	ctnRun := filepath.Join(ctnHome, "run")

	// Start build
	// Check existing images
	dockerImages := exec.Command("docker", "images")
	dockerImagesBytes, err := dockerImages.Output()
	if err != nil {
		fmt.Println("`docker images` execution error, please check whether your docker is correctly installed")
		panic(err)
	}
	var tplImgExist, pkgImgExist bool
	dockerImagesString := string(dockerImagesBytes)
	lines := bufio.NewScanner(strings.NewReader(dockerImagesString))
	for lines.Scan() {
		fields := strings.Fields(lines.Text())
		if len(fields) == 0 {
			continue
		}
		switch fields[0] {
		case imgTpl:
			tplImgExist = true
		case imgPkg:
			pkgImgExist = true
		}
	}

	if rcr {
		// Remove old docker images and create new
		fmt.Println("Removing old docker images")
		if pkgImgExist {
			dockerRmi := exec.Command("docker", "rmi", imgPkg)
			dockerRmi.Stdout = os.Stdout
			dockerRmi.Stderr = os.Stderr
			dockerRmi.Start()
			err := dockerRmi.Wait()
			if err == nil {
				pkgImgExist = false
			} else {
				fmt.Println("WARNING: Delete image failed")
			}
		}
		if tplImgExist {
			dockerRmi := exec.Command("docker", "rmi", imgTpl)
			dockerRmi.Stdout = os.Stdout
			dockerRmi.Stderr = os.Stderr
			dockerRmi.Start()
			err := dockerRmi.Wait()
			if err == nil {
				tplImgExist = false
			} else {
				fmt.Println("WARNING: Delete image failed")
			}
		}
	}

	if !pkgImgExist && !tplImgExist {
		// Generate image for compiler
		fmt.Println("Generate docker image for compiler")
		dockerBuild := exec.Command("docker", "build",
			"-t", imgTpl,
			"-f", filepath.Join(pathTpl, "Dockerfile"),
			"--build-arg", "DISTRO="+distro,
			"--build-arg", "ICC_KEY="+iccKey,
			filepath.Join(pth, "src"))
		dockerBuild.Stdout = os.Stdout
		dockerBuild.Stderr = os.Stderr
		dockerBuild.Start()
		err := dockerBuild.Wait()
		if err != nil {
			fmt.Println("ERROR: Generating image failed")
			panic(err)
		}
	}

	if !pkgImgExist {
		idU := exec.Command("id", "-u")
		id, err := idU.Output()
		if err != nil {
			fmt.Println("ERROR: Running `id -u` failed")
			panic(err)
		}
		fmt.Println("Generate docker image for package")
		dockerBuild := exec.Command("docker", "build",
			"-t", imgPkg,
			"-f", filepath.Join(pathSys, "Dockerfile"),
			"--build-arg", "IMAGE_TRIPLE="+imgTpl,
			"--build-arg", "UID="+string(id),
			"--build-arg", "USER="+ctnUser,
			"--build-arg", "USER_HOME="+ctnHome,
			"--build-arg", "ARG_PKG="+pkg,
			"--build-arg", "SYSTEM_TRIPLE="+sysTpl,
			filepath.Join(pth, "src"))
		dockerBuild.Stdout = os.Stdout
		dockerBuild.Stderr = os.Stderr
		dockerBuild.Start()
		err = dockerBuild.Wait()
		if err != nil {
			fmt.Println("ERROR: Generating image failed")
			panic(err)
		}
	}

	// Run container
	fmt.Println("Run docker container")
	dockerRun := exec.Command("docker", "run", "--rm",
		"--name", ctnName,
		"-v", pathPkg+":"+ctnRun,
		"-v", out+":"+ctnOut,
		imgPkg,
		filepath.Join(ctnRun, "run.sh"), opt, ctnOut)
	dockerRun.Stdout = os.Stdout
	dockerRun.Stderr = os.Stderr
	dockerRun.Start()
	err = dockerRun.Wait()
	if err != nil {
		fmt.Println("ERROR: container run failed")
		panic(err)
	}

	if cln {
		// Clean docker images generated
		dockerRmi := exec.Command("docker", "rmi", imgPkg, imgTpl)
		dockerRmi.Stdout = os.Stdout
		dockerRmi.Stderr = os.Stderr
		dockerRmi.Start()
		err := dockerRmi.Wait()
		if err == nil {
			pkgImgExist = false
		} else {
			fmt.Println("WARNING: Delete images failed")
		}
	}
}
