#
# Install Python CUDA programming toolchain
#
if [ ! -d /opt/anaconda3 ]; then
  Anaconda3Unit="/etc/systemd/system/anaconda3.service"
  (
  cat <<'ANACONDA3UNIT'
[Unit]
Description = install Anaconda toolchain
After = multi-user.target

[Service]
ExecStartPre = /usr/bin/wget --directory-prefix /tmp https://repo.anaconda.com/archive/Anaconda3-2018.12-Linux-x86_64.sh
ExecStart = /bin/bash /tmp/Anaconda3-2018.12-Linux-x86_64.sh -b -p /opt/anaconda3
ANACONDA3UNIT
  ) > $Anaconda3Unit

  systemctl enable --now --no-block anaconda3.service

  CudaPythonUnit="/etc/systemd/system/cudapython.service"
  (
  cat <<'CUDAPYTHONUNIT'
[Unit]
Description = install Python CUDA components

[Service]
ExecStart = /opt/anaconda3/bin/conda install numba cudatoolkit
CUDAPYTHONUNIT
  ) > $CudaPythonUnit

  CudaPythonPath="/etc/systemd/system/cudapython.path"
  (
  cat <<'CUDAPYTHONPATH'
[Unit]
Description = Install Python CUDA components when conda is available

[Path]
PathExists = /opt/anaconda3/bin/conda
CUDAPYTHONPATH
  ) > $CudaPythonPath

  systemctl enable --now --no-block cudapython.path
fi
