#
# Install Julia and the necessary CUDA programming packages
#
if [ ! -d /opt/julia/julia-1.1.0 ]; then
  mkdir /opt/julia
  cd /opt/julia

  Julia11Unit="/etc/systemd/system/julia-1.1.service"
  (
  cat <<'JULIA11UNIT'
[Unit]
Description = install Julia 1.1
After = multi-user.target

[Service]
ExecStartPre = /usr/bin/wget --directory-prefix /tmp https://julialang-s3.julialang.org/bin/linux/x64/1.1/julia-1.1.0-linux-x86_64.tar.gz
ExecStart = /bin/tar zxf /tmp/julia-1.1.0-linux-x86_64.tar.gz --directory /opt/julia
ExecStartPost = /usr/bin/ln -s /opt/julia/julia-1.1.0/bin/julia /usr/local/bin/julia
JULIA11UNIT
  ) > $Julia11Unit

  systemctl enable --now --no-block julia-1.1.service

  CudaJuliaUnit="/etc/systemd/system/cudajulia.service"
  (
  cat <<'CUDAJULIAUNIT'
[Unit]
Description = install Julia CUDA components

[Service]
ExecStart = /usr/local/bin/julia -e 'using Pkg; Pkg.add("CUDAnative"); Pkg.add("CUDAdrv"); Pkg.add("CuArrays")'
CUDAJULIAUNIT
  ) > $CudaJuliaUnit

  CudaJuliaPath="/etc/systemd/system/cudajulia.path"
  (
  cat <<'CUDAJULIAPATH'
[Unit]
Description = Install Julia CUDA components when /usr/local/bin/julia is available

[Path]
PathExists = /usr/local/bin/julia
CUDAJULIAPATH
  ) > $CudaJuliaPath

  systemctl enable --now --no-block cudajulia.path
fi
