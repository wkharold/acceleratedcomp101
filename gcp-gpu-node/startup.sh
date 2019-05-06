#
# Install required toolchain components, kernel headers, and development packages
#
yum update -y

yum install curl wget bc bzip2 gcc git kernel-devel-$(uname -r) kernel-headers-$(uname -r) -y
yum groupinstall 'Development Tools' -y

#
# Install common CUDA commands and libs
#
if ! rpm -q cuda-10-0; then
  curl -O http://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-repo-rhel7-10.0.130-1.x86_64.rpm
  rpm -i --force ./cuda-repo-rhel7-10.0.130-1.x86_64.rpm
  yum clean all
  rm -rf /var/cache/yum
  # Install Extra Packages for Enterprise Linux (EPEL) for dependencies
  yum install epel-release -y
  yum update -y
  yum install cuda-10-0 -y
fi

if ! rpm -q cuda-10-0; then
  yum install cuda-10-0 -y
fi

nvidia-smi -pm 1

#
# Configure for CUDA programming in Python
#
if [ ! -d /opt/anaconda3 ]; then
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/anaconda3-unit" -H "Metadata-Flavor: Google" > /etc/systemd/system/anaconda3.service
    systemctl enable --now --no-block anaconda3.service

    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/cudapython-path" -H "Metadata-Flavor: Google" > /etc/systemd/system/cudapython.path
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/cudapython-unit" -H "Metadata-Flavor: Google" > /etc/systemd/system/cudapython.service
    systemctl enable --now --no-block cudapython.path
fi

#
# Configure for CUDA programming in Juila
#
if [ ! -d /opt/julia ]; then
    mkdir /opt/julia

    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/julia-unit" -H "Metadata-Flavor: Google" > /etc/systemd/system/julia-1.1.service
    systemctl enable --now --no-block julia-1.1.service

    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/cudajulia-path" -H "Metadata-Flavor: Google" > /etc/systemd/system/cudajulia.path
    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/cudajulia-unit" -H "Metadata-Flavor: Google" > /etc/systemd/system/cudajulia.service
    systemctl enable --now --no-block cudajulia.path
fi

#
# Configure for CUDA programming in C++ using the Kokkos framework
#
if [ ! -d /opt/kokkos ]; then
    mkdir -p /opt/kokkos/repo

    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/kokkos-build" -H "Metadata-Flavor: Google" > /opt/kokkos/buildkokkos.sh
    chmod +x /opt/kokkos/buildkokkos.sh

    curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/kokkos-unit" -H "Metadata-Flavor: Google" > /etc/systemd/system/kokkos.service
    systemctl enable --now --no-block kokkos.service
fi
