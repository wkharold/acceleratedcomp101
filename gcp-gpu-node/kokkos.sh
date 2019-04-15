#
# Install kokkos CUDA C++ library/framework
#
if [ ! -d /opt/kokkos ]; then
  mkdir -p /opt/kokkos/repo

  KokkosBuild="/opt/kokkos/buildkokkos.sh"
  (
  cat <<'KOKKOSBUILD'
#!/bin/bash

cd /opt/kokkos

/opt/kokkos/repo/generate_makefile.bash --prefix=/usr/local
make kokkoslib
make install
KOKKOSBUILD
  ) > $KokkosBuild

  chmod a+x $KokkosBuild

  KokkosUnit="/etc/systemd/system/kokkos.service"
  (
  cat <<'KOKKOSUNIT'
[Unit]
Description = install kokkos library/framework
After = multi-user.target

[Service]
ExecStartPre = /usr/bin/git clone https://github.com/kokkos/kokkos.git /opt/kokkos/repo
ExecStart = /opt/kokkos/buildkokkos.sh
KOKKOSUNIT
  ) > $KokkosUnit

  systemctl enable --now --no-block kokkos.service
fi
