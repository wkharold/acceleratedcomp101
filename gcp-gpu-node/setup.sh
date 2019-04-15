#
# Install required toolchain components, kernel headers, and development packages
#
yum update -y

yum install wget bzip2 gcc git kernel-devel-$(uname -r) kernel-headers-$(uname -r) -y
