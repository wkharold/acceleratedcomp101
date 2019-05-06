#!/bin/bash

cd /opt/kokkos

/opt/kokkos/repo/generate_makefile.bash --prefix=/usr/local
make kokkoslib
make install
