TEMPLATEFILE:=optex-template.tex
WRITERFILE:=optex-writer.lua
DEFAULTSFILE:=optex-default.yaml
DEFAULTSSTANDALONEFILE:=optex-default-standalone.yaml
# PANDOCDATADIR:=~/.local/share/pandoc/
PANDOCDATADIR:=$(shell pandoc --version | sed -n '/^User data directory: .*/{s/^User data directory: \(.*\)/\1/g;p}')
TEMPLATEDIR:=$(PANDOCDATADIR)/templates/
WRITERDIR:=$(PANDOCDATADIR)/writers/
DEFAULTSDIR:=$(PANDOCDATADIR)/defaults/
PDFFILES=$(wildcard *.pdf)
TEXFILES=docs.tex
REFFILES=$(wildcard *.ref)
REPLACEMETS= OpTeX TeX



.PHONY: help
help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: docs 
docs: README.pdf README.md ## Generates documentation as a pdf file and a markdown file

docs.tex: docs.md | $(TEMPLATEFILE) $(WRITERFILE)
	pandoc -d $(DEFAULTSFILE) -f markdown -t $(WRITERFILE) $^ --template $(TEMPLATEFILE) >$@

README.pdf: docs.tex | docs.md
	optex $^
	optex $^
	mv docs.pdf $@

README.md: docs.md
	sed $(foreach repl, $(REPLACEMETS), -e 's;\\$(repl)/;$(repl);g') $^ >$@
	sed -i '1 { /^---/ { :a N; /\n---/! ba; d} }' $@

.PHONY: install
install: ensure_pandoc install_template install_writer install_defaults ## Installs the optex writer

.PHONY: ensure_pandoc
ensure_pandoc:




$(PANDOCDATADIR): ensure_pandoc
	mkdir -p $@

$(TEMPLATEDIR): $(PANDOCDATADIR)
	mkdir -p $@

$(WRITERDIR): $(PANDOCDATADIR)
	mkdir -p $@

$(DEFAULTSDIR): $(PANDOCDATADIR)
	mkdir -p $@

.PHONY: install_template
install_template: $(TEMPLATEFILE) | $(TEMPLATEDIR)
	cp -v $^ $(TEMPLATEDIR)$^

.PHONY: install_writer
install_writer: $(WRITERFILE) | $(WRITERDIR)
	cp -v $^ $(WRITERDIR)$^

.PHONY: install_defaults
install_defaults: $(DEFAULTSFILE) $(DEFAULTSSTANDALONEFILE) | $(DEFAULTSDIR) $(WRITERDIR) $(WRITERFILE)
	echo "writer: $(WRITERDIR)$(WRITERFILE)" > $(DEFAULTSDIR)optex.yaml
	sed '/^writer:.*/d' $(DEFAULTSFILE) >> $(DEFAULTSDIR)optex.yaml
	echo "writer: $(WRITERDIR)$(WRITERFILE)" > $(DEFAULTSDIR)optex-standalone.yaml
	sed '/^writer:.*/d' $(DEFAULTSSTANDALONEFILE) >> $(DEFAULTSDIR)optex-standalone.yaml


.PHONY: clean
clean: ## Cleans working directory, only for development purposes
	rm -rfv $(PDFFILES) $(TEXFILES) $(REFFILES) README.md



## TESTS

TESTRUNNER:=./test/bats/bin/bats
TESTDIR:=./test/tests
TESTS:= pandoc_tests.bats \
	header_tests/header_tests.bats \
	para_tests/para_tests.bats \
	emphasis_tests/emphasis_tests.bats \

.PHONY: test
test:  ## Runs all tests
	$(TESTRUNNER) $(patsubst %.bats,$(TESTDIR)/%.bats,$(TESTS))
