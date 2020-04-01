.PHONY: compile rel cover test typecheck doc ci

REBAR=./rebar3
SHORTSHA=`git rev-parse --short HEAD`
PKG_NAME_VER=${SHORTSHA}
HASH=$(shell git rev-parse HEAD)

OS_NAME=$(shell uname -s)

ifeq (${OS_NAME},FreeBSD)
make="gmake"
else
MAKE="make"
endif

compile:
	$(REBAR) compile

shell:
	$(REBAR) shell

clean:
	$(REBAR) clean

cover:
	$(REBAR) cover

test:
	$(REBAR) as test do ct --suite test/proxy_SUITE

ci:
	($(REBAR) do ct || (mkdir -p artifacts; tar -czf artifacts/test_log-$(HASH).tar.gz _build/test; false))
	$(REBAR) covertool generate
	codecov --required -f _build/test/covertool/libp2p.covertool.xml

typecheck:
	$(REBAR) dialyzer

doc:
	$(REBAR) edoc
