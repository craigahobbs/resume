.DEFAULT_GOAL := build/resume.pdf

build/env.build:
	python3 -m venv build/env
	build/env/bin/pip install -U pip setuptools
	build/env/bin/pip install rst2pdf
	touch $@

build/resume.pdf: resume.rst build/env.build
	build/env/bin/rst2pdf resume.rst -o $@
	ls -l $@

.PHONY: clean
clean:
	rm -rf build
