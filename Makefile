.DEFAULT_GOAL := all

RST2PDF_VERSION := 0.96

build/resume.pdf: resume.rst build/env.build
	build/env/bin/rst2pdf $< -o $@ -s $(basename $<).json

build/resume.html: resume.rst build/env.build
	build/env/bin/rst2html.py $< $@ --stylesheet-path $(basename $<).css

build/resume.txt: resume.rst
	tail -n +3 $< > $@

build/env.build:
	python3 -m venv build/env
	build/env/bin/pip install -U pip setuptools
	build/env/bin/pip install rst2pdf==$(RST2PDF_VERSION)
	touch $@

.PHONY: all
all: check build/resume.pdf build/resume.html build/resume.txt

.PHONY: check
check:
	python3 -c "open('resume.rst', 'rb').read().decode('ascii')"

.PHONY: clean
clean:
	rm -rf build

.PHONY: gh-pages
gh-pages: clean all
	if [ ! -d ../$(notdir $(CURDIR)).doc ]; then git clone -b gh-pages `git config --get remote.origin.url` ../$(notdir $(CURDIR)).doc; fi
	cd ../$(notdir $(CURDIR)).doc && git pull
	cp build/resume.* ../$(notdir $(CURDIR)).doc
	touch ../$(notdir $(CURDIR)).doc/.nojekyll
