all: technical_brief.pdf

scaled_poster.pdf: poster.pdf
	pdfcpu resize -- "scale:0.175" poster.pdf scaled_poster.pdf

technical_brief.pdf: mermaid/out scaled_poster.pdf document.pdf
	pdfcpu merge technical_brief.pdf document.pdf scaled_poster.pdf

mermaid/out: ./mermaid
	cd mermaid && mkdir out && bash generate.sh
document.pdf:
	typst compile document.typ

watch: document.typ
	fd -e typ | entr make

clean:
	rm -f technical_brief.pdf
	rm -f scaled_poster.pdf
	rm -f document.pdf

.PHONY: clean watch


