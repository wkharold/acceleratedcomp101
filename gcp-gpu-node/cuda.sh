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
# Verify that CUDA installed; retry if not.
if ! rpm -q cuda-10-0; then
  yum install cuda-10-0 -y
fi
# Enable persistence mode
nvidia-smi -pm 1
