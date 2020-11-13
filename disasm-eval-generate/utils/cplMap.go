package utils

// CplToDistroMap is the map the match supported compilers to their original dorcker images
var CplToDistroMap map[string]string = map[string]string{
	"gnu-clang-3.8.0":     "ubuntu:16.04",
	"gnu-clang++-3.8.0":   "ubuntu:16.04",
	"gnu-clang-6.0.0":     "ubuntu:18.04",
	"gnu-clang++-6.0.0":   "ubuntu:18.04",
	"gnu-gcc-5.4.0":       "ubuntu:16.04",
	"gnu-g++-5.4.0":       "ubuntu:16.04",
	"gnu-gcc-7.5.0":       "ubuntu:18.04",
	"gnu-g++-7.5.0":       "ubuntu:18.04",
	"gnu-icc-19.1.1.219":  "ubuntu:18.04",
	"gnu-icpc-19.1.1.219": "ubuntu:18.04",
	"msvc-cl-19.25.28614": "pangine/msvc-wine",
}
