# $cur_dir_save=$(Get-Location)
Import-Module "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell d7e85ca7 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"

# Set-Location $cur_dir_save


# cmd.exe /c "call `"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat`" && set > %temp%\vcvars.txt"

# Get-Content "$env:temp\vcvars.txt" | Foreach-Object {
#     if ($_ -match "^(.*?)=(.*)$") {
#         Set-Content "env:\$($matches[1])" $matches[2]
#     }
# }


$env:CMAKE_BUILD_TYPE="RelWithDebInfo"
$env:CONFIG="RelWithDebInfo"

$env:TMP_DIR_WIN="$(Get-Location)\tmp"
$env:TMP_DIR="$(Get-Location)\tmp"

$paths = $env:PATH -split ';'
if (-not ($paths -contains $env:TMP_DIR + "\bin")) {
    $env:PATH = "$env:TMP_DIR\bin;$env:PATH"
}

$env:USE_CUDA="1"

$env:USE_PRECOMPILED_HEADERS="0"

$env:MAGMA_HOME="$(Get-Location)/third_party/magma"
$env:CMAKE_INCLUDE_PATH="C:\Program Files (x86)\Intel\oneAPI\mkl\latest\include"
# $env:LIB="$(Get-Location)\third_party\mkl\lib;$env:CONDA_PREFIX\libs;$env:LIB"
$desiredMklLibPath = "C:\Program Files (x86)\Intel\oneAPI\mkl\2023.2.0\lib\intel64"
$existingLibEnv = $env:LIB -split ';'
if (-not ($existingLibEnv -contains $desiredMklLibPath)) {
    $env:LIB = "$desiredMklLibPath;$env:LIB"
}

$env:libuv_ROOT="C:\Program Files\libuv"

$env:CUSPARSELT_ROOT="$(Get-Location)/third_party/libcusparse_lt"

$env:CUDA_VERSION="12.2"
$env:CUDA_PATH="C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v$env:CUDA_VERSION"


$env:CUDA_VERSION_SUFFIX= $env:CUDA_VERSION.Replace('.', '_')
$new_cuda_v_env_name = "CUDA_VERSION_V" + $env:CUDA_VERSION_SUFFIX
Set-Item "env:$new_cuda_v_env_name" $env:CUDA_PATH

$env:CUDNN_LIB_DIR="$env:CUDA_PATH\lib\x64"
$env:CUDA_TOOLKIT_ROOT_DIR="$env:CUDA_PATH"
$env:CUDNN_ROOT_DIR="$env:CUDA_PATH"
$env:NVTOOLSEXT_PATH="C:\Program Files\NVIDIA Corporation\Nsight Compute 2023.2.2\host\target-windows-x64\nvtx"
# $env:PATH="$env:CUDA_PATH\bin;$env:CUDA_PATH\libnvvp;$env:PATH"


$env:DISTUTILS_USE_SDK="1"
$env:TORCH_CUDA_ARCH_LIST="8.9"
$env:CMAKE_CUDA_ARCHITECTURES="89"

$env:SCCACHE_IDLE_TIMEOUT="0"
$env:SCCACHE_IGNORE_SERVER_IO_ERROR="1"
sccache --stop-server
sccache --start-server
sccache --zero-stats
$env:CC="sccache-cl"
$env:CXX="sccache-cl"

$env:CMAKE_GENERATOR="Ninja"

$env:CUDA_NVCC_EXECUTABLE="$(Get-Location)/tmp/bin/nvcc.bat"
$env:CMAKE_CUDA_COMPILER="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v12.2/bin/nvcc.exe"
$env:CMAKE_CUDA_COMPILER_LAUNCHER="randomtemp.exe;sccache.exe"

$env:PYTORCH_BUILD_VERSION="2.1.0"
$env:PYTORCH_BUILD_NUMBER="1"


python setup.py bdist_wheel
if($LASTEXITCODE -ne 0)
{
    Exit $LASTEXITCODE
}
sccache --show-stats

$CurrentDateTime = Get-Date -Format "yyMMdd-HHmmss"

sccache --show-stats --stats-format json | jq .stats > "sccache-stats-local_$CurrentDateTime.json"
sccache --stop-server

