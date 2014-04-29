#!/bin/bash
# ./build.sh x86
# ./build.sh arm
# ./build.sh android


exec_cmd() {
	cmd=$1
	echo "executing command $cmd"
	eval $cmd
}

build_coremark() {
	SRCPATH="400.coremark"
	pushd $SRCPATH
	if [ $ARCH = "x86" ]
	then
		make PORT_DIR=linux64 CC=$GCC compile
		cp coremark.exe ../${OBJPATH}/coremark
		make PORT_DIR=linux64 CC=$GCC compile clean
	fi
	if [ $ARCH = "arm" ]
	then
		make PORT_DIR=linux CC=$GCC compile
		cp coremark.exe ../${OBJPATH}/coremark
		make PORT_DIR=linux64 CC=$GCC compile clean
	fi
	popd
}

build_linpack() {
	SRCPATH="401.linpack"
	pushd $SRCPATH
	${GCC} -O2 -DDP -o linpack_dp linpack.c
	${GCC} -O2 -DSP -o linpack_sp linpack.c
	
	popd
	mv ${SRCPATH}/linpack_sp ${OBJPATH}
	mv ${SRCPATH}/linpack_dp ${OBJPATH}
}

build_scimark() {
	SRCPATH="402.scimark"
	pushd $SRCPATH
	make CC=$GCC
	cp scimark2 ../${OBJPATH}
	make CC=$GCC clean
	popd
}

build_lmbench() {
	SRCPATH="490.lmbench"
	pushd $SRCPATH
	make OS=lmbench  CC=$GCC
	cp -rf bin/lmbench ../${OBJPATH}
	rm -rf bin
	popd
}

build_openssl() {
	SRCPATH="403.openssl"
	pushd $SRCPATH
	if [ $ARCH = "x86" ]
	then
		CC=$GCC ./Configure linux-x86_64
		make
	fi
	if [ $ARCH = "arm" ]
	then
		CC=$GCC ./Configure linux-armv4
		make
	fi
	cp apps/openssl ../${OBJPATH}
	make clean
	popd
}

build_cachebench() {
	SRCPATH="410.cachebench"
	pushd $SRCPATH
	make CC=$GCC
	mv cachebench ../${OBJPATH}
	popd
}


build_memspeed() {
	SRCPATH="412.memspeed"
	pushd $SRCPATH
	make CC=$GCC
	mv memspeed ../${OBJPATH}
	popd
}

build_iperf() {
	SRCPATH="420.iperf"
	pushd $SRCPATH
	if [ $ARCH = "arm" ]
	then
		ac_cv_func_malloc_0_nonnull=yes ./configure --host=$ARMCROSS
	fi
	if [ $ARCH = "x86" ]
	then
		./configure
	fi
	make
	cp src/iperf ../${OBJPATH}
	make distclean
	popd
}

build_netperf() {
	SRCPATH="421.netperf"
	pushd $SRCPATH
	if [ $ARCH = "arm" ]
	then
		ac_cv_func_setpgrp_void=yes ./configure --host=$ARMCROSS
		ac_cv_func_malloc_0_nonnull=yes ./configure --host=$ARMCROSS
	fi
	if [ $ARCH = "x86" ]
	then
		./configure
	fi
	make
	cp src/netperf ../${OBJPATH}
	cp src/netserver ../${OBJPATH}
	make distclean
	popd
}

build_iozone() {
	SRCPATH="430.iozone"
	pushd $SRCPATH
	if [ $ARCH = "x86" ]
	then
		 make linux-AMD64
	fi

	if [ $ARCH = "arm" ]
	then
		make linux-arm CC=arm-linux-gnueabihf-gcc GCC=arm-linux-gnueabihf-gcc
	fi
	cp iozone ../${OBJPATH}
	cp fileop ../${OBJPATH}
	make clean
	popd
}

build_prepare() {
	rm -rf ${OBJPATH}
	mkdir -p ${OBJPATH}
	cp run.sh ${OBJPATH}
}

if [ $# -eq 0 ]
then
	ARCH=x86
else
	ARCH=$1
fi

if [ $ARCH = "arm" ]
then
	ARMCROSS=arm-linux-gnueabihf
	ARMCC=${ARMCROSS}-gcc
	GCC=${ARMCC}
	OBJPATH=obj/arm
fi

if [ $ARCH = "x86" ]
then
	GCC=gcc
	OBJPATH=obj/x86
fi


build_prepare
#build_linpack
#build_coremark
#build_scimark
#build_lmbench
#build_openssl

#build_cachebench
#build_memspeed

# network benchmark building
build_iperf
build_netperf

# disk/filesystem benchmark building
build_iozone
