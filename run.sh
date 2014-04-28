#!/bin/bash

#
#cpu benchmark
#
echo "cpu frequency"
./lmbench/mhz
echo "cpu instruction latency"
./lmbench/lat_ops
./coremark
./linpack_sp
./linpack_dp
./scimark2
./openssl speed

#
# memory benchmark
#

