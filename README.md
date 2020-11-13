# Disassembler Evaluation - Test Suite Source Programs

The repo contains source test suite programs used as examples in the
disassembler ground truth generation and disassemblers accuracy evaluations
within the Pangine Project

## Packages
### linux-C
The repo presently support 15 different independent Linux-C test suite projects:
- [7zip-19.00](https://www.7-zip.org/)
- [Capstone v4.0.2](https://www.capstone-engine.org/)
- [coreutils v8.25](https://www.gnu.org/software/coreutils/)
- [Exim v4.86](https://exim.org/)
- [Lighttpd v1.4.39](https://www.lighttpd.net/)
- [MIT large single compilation - bzip2 (16:10:08 EST 2006)](https://people.csail.mit.edu/smcc/projects/single-file-programs/)
- [MIT large single compilation - gzip (16:10:08 EST 2006)](https://people.csail.mit.edu/smcc/projects/single-file-programs/)
- [MIT large single compilation - oggenc (16:10:08 EST 2006)](https://people.csail.mit.edu/smcc/projects/single-file-programs/)
- [MIT large single compilation - gcc (16:10:08 EST 2006)](https://people.csail.mit.edu/smcc/projects/single-file-programs/)
- [NGINX v1.8.0](https://www.nginx.com/)
- [OpenSSH v7.1p2](https://www.openssh.com/)
- [PCRE2 v10.35](https://www.pcre.org/)
- [sqlite v3.30.1](https://www.sqlite.org/index.html)
- [vim v8.2.0821](https://www.vim.org/)
- [vsftpd v3.0.3](https://security.appspot.com/vsftpd.html)

### msvc-C
The repo presently support 7 different independent msvc-C test suite projects:
- [7zip-19.00](https://www.7-zip.org/)
- [Capstone v4.0.2](https://www.capstone-engine.org/)
- [MIT large single compilation - bzip2 (16:10:08 EST 2006)](https://people.csail.mit.edu/smcc/projects/single-file-programs/)
- [PCRE2 v10.35](https://www.pcre.org/)
- [PuTTY v0.73](https://www.putty.org/)
- [sqlite v3.30.1](https://www.sqlite.org/index.html)
- [vim v8.2.0821](https://www.vim.org/)

## To Install
```bash
go get -u github.com/pangine/disasm-eval-sources/...
```

## To Compile
Assuming you want to build `OpenSSH v7.1p2` using x64 gnu-gcc-7.5.0 with a customized build option `-O3`, and you want to store your results into */path_to_test_cases/*.

The llvm triple for this test case should be **x86_64-pc-linux-gnu-elf**

Here is the command to run:
```bash
OUTPUTDIR="/path_to_test_cases"
ARCH="x86_64-pc"
SYS="linux"
COMPILER="gnu-gcc-7.5.0"
OBJECT="gnu-elf"
PACKAGE="openssh-7.1p2"
OPTION="-O3"

disasm-eval-generate -out ${OUTPUTDIR} -arch ${ARCH} -sys ${SYS} -cpl ${COMPILER} -obj ${OBJECT} -pkg ${PACKAGE} -opt ${OPTION}
```

You need to make sure that there is a directory *images/${ARCH}/${SYS}/{COMPILER}/PACKAGE/* in this repo for a successful compilation.

If you are using `icc`, you need to give your icc key using argument `-icc_key`.

If you are using `msvc`, you need to install the docker image `msvc-wine` from [msvc-wine](https://github.com/pangine/msvc-wine/tree/2004-ninja) (Please use the *2004-ninja* branch).

Considering the way that Microsoft distribute the msvc contents, the version you install may not be the same as the version we specified in our *images* folder. If you found that the compilation failed, please post an issue (Or you can go into the msvc Dockerfile to change the PATH it uses).

All the Linux binaries will be compiled using `-save-temps` and `-g` with your input option.

All the msvc binaries will be compiled using `/FAcs` and `/Z7` with your input option, and linked using `/DEBUG:FULL` and `/MAP`.

For more information about the script, run `--help` argument.

## To Add Project
To add a new project as test suite, you need to look at two directories
- src/packages
- images/

In the *src/packages*, you need to create a new folder including the xz archive of the source code and some subdirectories to install dependency packages.

In the *images/*, you need to go all the way into the compiler your want to use, and add a new folder containing your compilation `run.sh` scripts.

You can reference the files for existing projects.
