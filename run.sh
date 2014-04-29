#!/bin/bash

run_bwmem() {
	HALF="512 1k 2k 4k 8k 16k 32k 64k 128k 256k 512k 1m"
	ALL="$HALF 2m"
	SYNC_MAX="4"

	echo "**        lmbench bwmem benchmark       **"
        echo "libc bcopy unaligned"
        for i in $HALF; do ./lmbench/bw_mem -P $SYNC_MAX $i bcopy; done;

        echo "libc bcopy aligned"
        for i in $HALF; do ./lmbench/bw_mem -P $SYNC_MAX $i bcopy conflict; done; 

        echo "Memory bzero bandwidth"
        for i in $ALL; do ./lmbench/bw_mem -P $SYNC_MAX $i bzero; done;

        echo "unrolled bcopy unaligned"
        for i in $HALF; do ./lmbench/bw_mem -P $SYNC_MAX $i fcp; done;

        echo "unrolled partial bcopy unaligned"
        for i in $HALF; do ./lmbench/bw_mem -P $SYNC_MAX $i cp; done;

        echo "Memory read bandwidth"
        for i in $ALL; do ./lmbench/bw_mem -P $SYNC_MAX $i frd; done;

        echo "Memory partial read bandwidth"
        for i in $ALL; do ./lmbench/bw_mem -P $SYNC_MAX $i rd; done;

        echo "Memory write bandwidth"
        for i in $ALL; do ./lmbench/bw_mem -P $SYNC_MAX $i fwr; done;

        echo "Memory partial write bandwidth"
        for i in $ALL; do ./lmbench/bw_mem -P $SYNC_MAX $i wr; done;

        echo "Memory partial read/write bandwidth"
        for i in $ALL; do ./lmbench/bw_mem -P $SYNC_MAX $i rdwr; done;

	echo "                 "
}

run_cpubench() {
	echo "**      lmbench cpu frequency      **"           1>>result.txt  2>>error.txt
	./lmbench/mhz                  1>>result.txt  2>>error.txt
	echo "           "             1>>result.txt  2>>error.txt
	echo "**      lmbench cpu instruction latency      **" 1>>result.txt  2>>error.txt
	./lmbench/lat_ops              1>>result.txt  2>>result.txt
	echo "           "             1>>result.txt  2>>error.txt

	./coremark              1>>result.txt  2>>error.txt
	./linpack_sp            1>>result.txt  2>>error.txt
	./linpack_dp            1>>result.txt  2>>error.txt
	./scimark2              1>>result.txt  2>>error.txt

	echo "           "             1>>result.txt  2>>error.txt
	./openssl speed         1>>result.txt  2>>error.txt
}

run_membench() {
	echo "**     cachebench test          **"        1>>result.txt  2>>error.txt
	./cachebench            1>>result.txt  2>>error.txt

	echo "**     memspeed test          **"        1>>result.txt  2>>error.txt
	./memspeed              1>>result.txt  2>>result.txt
	echo "           "             1>>result.txt  2>>error.txt

	run_bwmem		1>>result.txt  2>>result.txt
	echo "**     lmbench stream test          **"        1>>result.txt  2>>error.txt
	lmbench/stream -P 4 -M 8M       1>>result.txt  2>>result.txt
	lmbench/stream -P 4 -v 2 -M 8M  1>>result.txt  2>>result.txt
}

#
#cpu benchmark
#
run_cpubench

#
# memory benchmark
#
run_membench

