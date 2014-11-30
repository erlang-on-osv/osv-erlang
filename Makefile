.PHONY: all

OTP_VERSION=17.3

all: | configure compile ROOTFS install

otp_src_$(OTP_VERSION).tar.gz:
	wget -O "$@.temp" "http://www.erlang.org/download/otp_src_$(OTP_VERSION).tar.gz"
	mv "$@.temp" "$@"

otp_src_$(OTP_VERSION): otp_src_$(OTP_VERSION).tar.gz
	tar xvf "$<"

configure: otp_src_$(OTP_VERSION)
	cd otp_src_$(OTP_VERSION); export ERL_TOP=$(CURDIR)/otp_src_$(OTP_VERSION) CFLAGS=-fpie LDFLAGS=-pie; ./configure -prefix=/usr --disable-silent-rules --disable-threads --disable-smp-support --disable-kernel-poll --disable-sctp --disable-hipe --disable-megaco-flex-scanner-lineno --disable-megaco-reentrant-flex-scanner --enable-builtin-zlib --without-termcap --without-javac --without-ssl --without-wx --without-asn1 --without-common_test --without-cosEvent --without-cosEventDomain --without-cosFileTransfer --without-cosNotification --without-cosProperty --without-cosTime --without-cosTransactions --without-crypto --without-debugger --without-dialyzer --without-diameter --without-edoc --without-eldap --without-erl_docgen --without-erl_interface --without-et --without-eunit --without-gs --without-hipe --without-ic --without-jinterface --without-megaco --without-mnesia --without-observer --without-odbc --without-orber --without-ose --without-os_mon --without-otp_mibs --without-percept --without-public_key --without-snmp --without-ssl --without-ssl --without-test_server --without-tools --without-typer --without-webtool --without-xmerl

compile:
	cd otp_src_$(OTP_VERSION); export ERL_TOP=$(CURDIR)/otp_src_$(OTP_VERSION); make

ROOTFS:
	mkdir ROOTFS

install:
	cd otp_src_$(OTP_VERSION); export ERL_TOP=$(CURDIR)/otp_src_$(OTP_VERSION) DESTDIR=$(CURDIR)/ROOTFS; make install
