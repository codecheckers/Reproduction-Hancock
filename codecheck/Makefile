## steps:
## make run
## make 


all: codecheck.pdf


codecheck.pdf: hancock1992-codecheck.Rmd preamble.sty ../codecheck.yml
	Rscript -e 'rmarkdown::render("$<", "pdf_document")'
	cp hancock1992-codecheck.pdf codecheck.pdf

hancock1992-codecheck.html: hancock1992-codecheck.Rmd ../codecheck.yml
	Rscript -e 'rmarkdown::render("$<")'

.PHONY: run clean

clean:
	rm -fr davies-codecheck.pdf outputs

## This takes just a minute or so to re-make the pdf outputs

run:
	cd ..; Rscript UK-view.R

