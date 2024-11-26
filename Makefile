OUT_DIR=output
IN_DIR=markdown
STYLES_DIR=styles
STYLE=chmduquesne

all: html pdf

pdf: init
	for f in $(OUT_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.pdf; \
		pandoc --standalone  --include-in-header $(STYLES_DIR)/$(STYLE).css \
			--from markdown --to pdf \
			--variable papersize=A4 \
			--pdf-engine=wkhtmltopdf \
			--output $(OUT_DIR)/$$FILE_NAME.pdf $$f > /dev/null; \
		okular $(OUT_DIR)/$$FILE_NAME.pdf; \
	done

html: init
	for f in $(OUT_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.html; \
		pandoc --standalone --include-in-header $(STYLES_DIR)/$(STYLE).css \
			--lua-filter=pdc-links-target-blank.lua \
			--from markdown --to html \
			--output $(OUT_DIR)/$$FILE_NAME.html $$f \
			--metadata pagetitle=$$FILE_NAME;\
		chromium $(OUT_DIR)/$$FILE_NAME.html; \
	done

init: dir example version
	for f in $(IN_DIR)/*.md.jinja2; do \
		FILE_NAME=`basename $$f | sed 's/.md.jinja2//g'`; \
		jinja2 $(IN_DIR)/$$FILE_NAME.md.jinja2 input.yaml --format=yaml > $(OUT_DIR)/$$FILE_NAME.md; \
	done

dir:
	mkdir -p $(OUT_DIR)

version:
	PANDOC_VERSION=`pandoc --version | head -1 | cut -d' ' -f2 | cut -d'.' -f1`; \
	if [ "$$PANDOC_VERSION" -eq "2" ]; then \
		SMART=-smart; \
	else \
		SMART=--smart; \
	fi \

example:
	test -e input.yaml || cp input.yaml.example input.yaml

clean:
	rm -f $(OUT_DIR)/*
