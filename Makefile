.PHONY: all

OTP_VERSION=17.3

all: | configure compile ROOTFS install

otp_src_$(OTP_VERSION).tar.gz:
	wget -O "$@.temp" "http://www.erlang.org/download/otp_src_$(OTP_VERSION).tar.gz"
	mv "$@.temp" "$@"

otp_src_$(OTP_VERSION): otp_src_$(OTP_VERSION).tar.gz
	tar xvf "$<"

configure: otp_src_$(OTP_VERSION)
	cd otp_src_$(OTP_VERSION); export ERL_TOP=$(CURDIR)/otp_src_$(OTP_VERSION) CFLAGS=-fpie LDFLAGS=-pie; ./configure -prefix=/usr --disable-threads --disable-smp-support --disable-hipe --without-hipe --without-odbc --without-os_mon --enable-builtin-zlib --without-termcap --without-wx --without-erl_interface --without-javac --without-jinterface

compile:
	cd otp_src_$(OTP_VERSION); export ERL_TOP=$(CURDIR)/otp_src_$(OTP_VERSION); make

ROOTFS:
	mkdir ROOTFS

install:
	cd otp_src_$(OTP_VERSION); export ERL_TOP=$(CURDIR)/otp_src_$(OTP_VERSION) DESTDIR=$(CURDIR)/ROOTFS; make install
	find ROOTFS -name '*.so' | xargs -I {} ldd {} | grep -Po '(?<=> )/[^ ]+' | sort | uniq | grep -Pv 'lib(c|dl|m|util|rt|pthread).so' | xargs -I {} install -D -T {} ROOTFS{}
