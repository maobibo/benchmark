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
build_linpack
build_coremark
build_scimark

