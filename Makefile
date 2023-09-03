all: before_install before_script make4ht src/*
	mkdir -p output/html
	mkdir -p output/pdf
	(cd src && exec pdflatex index.tex)
	(cd src && exec pdflatex index.tex)
	(cd src && exec pdflatex index.tex)
	(cd src && exec make4ht -uf html5+mathjaxnode -c ../my.cfg index.tex "html,4")
	(cd src && exec mv *.css *.html ../output/html)
	(cd src && exec cp index.pdf ../output/html)
	find ./src -type f -not \( -name '*.tex' \) -delete
	python3 add-pdf-url.py output/html/index.html

make4ht:
	./scripts/_make4ht.sh

before_install:
	sudo apt-get -qq update && sudo apt-get install -y --no-install-recommends texlive-full pandoc latexmk pdf2svg
	sudo apt-get install python3 python3-pip python3-setuptools
	pip3 install --upgrade pip
	pip3 install beautifulsoup4
	npm -g install mathjax-node-page

before_script:
	chmod +x ./scripts/_make4ht.sh
	chmod +x ./scripts/_deploy.sh

.PHONY: clean
clean ::
	find ./src -type f -not \( -name '*.tex' \) -delete
	-rm -rf output
