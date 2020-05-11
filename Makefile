.DEFAULT_GOAL := all

RST2PDF_VERSION := 0.97

build/resume.pdf: resume.rst resume.json build/env.build
	build/env/bin/rst2pdf $< -o $@ -s $(basename $<).json

build/resume.html: resume.rst resume.css build/env.build
	build/env/bin/rst2html.py $< $@ --stylesheet-path $(basename $<).css

build/resume.txt: resume.rst
	tail -n +3 $< > $@

build/check.build: resume.rst
	mkdir -p $(dir $@)
	python3 -c "open('$<', 'rb').read().decode('ascii')"
	touch $@

build/env.build:
	python3 -m venv build/env
	build/env/bin/pip install -U pip setuptools
	build/env/bin/pip install rst2pdf==$(RST2PDF_VERSION)
	touch $@

.PHONY: all
all: build/check.build build/resume.pdf build/resume.html build/resume.txt

.PHONY: clean
clean:
	rm -rf build

.PHONY: gh-pages
gh-pages: clean all
	if [ ! -d ../$(notdir $(CURDIR)).gh-pages ]; then git clone -b gh-pages `git config --get remote.origin.url` ../$(notdir $(CURDIR)).gh-pages; fi
	cd ../$(notdir $(CURDIR)).gh-pages && git pull
	cp build/resume.* ../$(notdir $(CURDIR)).gh-pages
	touch ../$(notdir $(CURDIR)).gh-pages/.nojekyll
