# Makefile for generating R packages.
# 2011 Andrew Redd
# 2014 Giuseppe Acito

PKG_VERSION=$(shell grep -i ^version DESCRIPTION | cut -d : -d \  -f 2)
PKG_NAME=$(shell grep -i ^package DESCRIPTION | cut -d : -d \  -f 2)

R_EXEC := R
R_SCRIPT := Rscript
R_FILES := $(wildcard R/*.[R|r])
SRC_FILES := $(wildcard src/*) $(addprefix src/, $(COPY_SRC))
PKG_FILES := DESCRIPTION NAMESPACE $(R_FILES) $(SRC_FILES)
PKG_FILE := $(PKG_NAME)_$(PKG_VERSION).tar.gz

.PHONY: NAMESPACE list autotest coverage changelog CHANGELOG.md

tarball: $(PKG_FILE)

$(PKG_FILE): $(PKG_FILES)
	$(R_EXEC) --vanilla CMD build .

build: $(PKG_FILE)

check:
	$(R_SCRIPT) -e 'devtools::check()'

install: $(PKG_FILE)
	$(R_EXEC) --vanilla CMD INSTALL $(PKG_FILE)

NAMESPACE: $(R_FILES)
	$(R_SCRIPT) -e "devtools::document()"

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
	$(R_SCRIPT) autotest.r

coverage:
	$(R_SCRIPT) -e 'covr::package_coverage(path=".")'

test:
	$(R_SCRIPT) -e 'devtools::test()'

CHANGELOG.md:
	gitchangelog | grep -v "git-svn-id" > CHANGELOG.md

changelog: CHANGELOG.md
