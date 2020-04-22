.DEFAULT_GOAL := all

RST2PDF_VERSION := 0.96

resume.pdf: resume.rst build/env.build
	build/env/bin/rst2pdf $< -o $@

resume.html: resume.rst build/env.build
	build/env/bin/rst2html.py $< $@

resume.txt: resume.rst
	tail -n +3 $< > $@

build/env.build:
	python3 -m venv build/env
	build/env/bin/pip install -U pip setuptools
	build/env/bin/pip install rst2pdf==$(RST2PDF_VERSION)
	touch $@

.PHONY: all
all: check resume.pdf resume.html resume.txt

.PHONY: check
check:
	python3 -c "open('resume.rst', 'rb').read().decode('ascii')"

.PHONY: clean
clean:
	rm -rf build
