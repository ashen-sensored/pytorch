set CMAKE_BUILD_TYPE=Debug

set TMP_DIR_WIN=%CD%\tmp
set TMP_DIR=%CD%\tmp
set PATH=C:\Program Files\CMake\bin;C:\Program Files\7-Zip;C:\ProgramData\chocolatey\bin;C:\Program Files\Git\cmd;C:\Program Files\Amazon\AWSCLI;C:\Program Files\Amazon\AWSCLI\bin;%TMP_DIR%\bin;%PATH%

set USE_CUDA=1

set MAGMA_HOME=%CD%/third_party/magma
set "CMAKE_INCLUDE_PATH=C:\Program Files (x86)\Intel\oneAPI\mkl\latest\include;%CMAKE_INCLUDE_PATH%"
rem set LIB=%CD%\third_party\mkl\lib;%CONDA_PREFIX%\libs;%LIB%
set "LIB=C:\Program Files (x86)\Intel\oneAPI\mkl\2023.2.0\lib\intel64;%LIB%"

set libuv_ROOT=C:\Program Files\libuv

set CUSPARSELT_ROOT=%CD%/third_party/libcusparse_lt

call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat"

set CUDA_VERSION=12.2
set CUDA_PATH=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v%CUDA_VERSION%


set VERSION_SUFFIX=%CUDA_VERSION:.=_%
set CUDA_PATH_V%VERSION_SUFFIX%=%CUDA_PATH%

set CUDNN_LIB_DIR=%CUDA_PATH%\lib\x64
set CUDA_TOOLKIT_ROOT_DIR=%CUDA_PATH%
set CUDNN_ROOT_DIR=%CUDA_PATH%
set NVTOOLSEXT_PATH=C:\Program Files\NVIDIA Corporation\Nsight Compute 2023.2.2\host\target-windows-x64\nvtx
set PATH=%CUDA_PATH%\bin;%CUDA_PATH%\libnvvp;%PATH%

set DISTUTILS_USE_SDK=1
set TORCH_CUDA_ARCH_LIST=8.9
set CMAKE_CUDA_ARCHITECTURES=89

set SCCACHE_IDLE_TIMEOUT=0
set SCCACHE_IGNORE_SERVER_IO_ERROR=1
sccache --stop-server
sccache --start-server
sccache --zero-stats
set CC=sccache-cl
set CXX=sccache-cl

set CMAKE_GENERATOR=Ninja

set CUDA_NVCC_EXECUTABLE=../tmp/bin/nvcc.bat
set CMAKE_CUDA_COMPILER=C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.2/bin/nvcc.exe
set CMAKE_CUDA_COMPILER_LAUNCHER=randomtemp.exe;sccache.exe

set PYTORCH_BUILD_VERSION=2.1.0
set PYTORCH_BUILD_NUMBER=1

python setup.py install
if errorlevel 1 exit /b
if not errorlevel 0 exit /b
sccache --show-stats

rem Get the date and time parts
set year=%date:~10,4%
set month=%date:~4,2%
set day=%date:~7,2%
set hour=%time:~0,2%
set minute=%time:~3,2%
set second=%time:~6,2%

rem Remove leading zero if hour is less than 10
if %hour:~0,1% equ 0 set hour=%hour:~1,1%

rem Create the datetime suffix
set datetime_suffix=%year%%month%%day%_%hour%%minute%%second%

sccache --show-stats --stats-format json | jq .stats > sccache-stats-local-%datetime_suffix%.json
sccache --stop-server


