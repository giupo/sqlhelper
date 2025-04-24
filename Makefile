# Makefile for generating R packages.
# 2011 Andrew Redd
# 2014 Giuseppe Acito

PKG_VERSION=$(shell grep -i ^version DESCRIPTION | cut -d : -d \  -f 2)
PKG_NAME=$(shell grep -i ^package DESCRIPTION | cut -d : -d \  -f 2)


R_BIN ?= R
RSCRIPT_BIN ?= Rscript

R_FILES := $(wildcard R/*.[R|r])
SRC_FILES := $(wildcard src/*) $(addprefix src/, $(COPY_SRC))
PKG_FILES := DESCRIPTION NAMESPACE $(R_FILES) $(SRC_FILES)
PKG_FILE := $(PKG_NAME)_$(PKG_VERSION).tar.gz

.PHONY: NAMESPACE list autotest coverage changelog NEWS.md

tarball: $(PKG_FILE)

$(PKG_FILE): $(PKG_FILES)
	$(R_BIN) --vanilla CMD build .

build: $(PKG_FILE)

check:
	$(RSCRIPT_BIN) -e 'devtools::check()'

install: $(PKG_FILE)
	$(R_BIN) --vanilla CMD INSTALL $(PKG_FILE)

NAMESPACE: $(R_FILES)
	$(RSCRIPT_BIN) -e "devtools::document()"

clean:
	-rm -f $(PKG_FILE)
	-rm -r -f $(PKG_NAME).Rcheck
	-rm -r -f man/*
	-rm -f src/*.so src/*.o

list:
	@echo "R files:"
	@echo $(R_FILES)
	@echo "Source files:"
	@echo $(SRC_FILES)

autotest:
	$(RSCRIPT_BIN) autotest.r

coverage:
	$(RSCRIPT_BIN) -e 'covr::package_coverage(path=".")'

zero_coverage:
	$(RSCRIPT_BIN) -e 'covr::zero_coverage(covr::package_coverage(path = "."))'
test:
	$(RSCRIPT_BIN) -e 'devtools::test()'

NEWS.md:
	gitchangelog | grep -v "git-svn-id" > NEWS.md
	git add NEWS.md && git commit -am "updates NEWS.md"

changelog: NEWS.md

install_deps:
	$(RSCRIPT_BIN) -e 'deps <- pak::pkg_deps("."); pak::pak(deps[deps$$type=="standard", "ref"])'