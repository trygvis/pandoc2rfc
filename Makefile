SHELL = /bin/sh

PATH := $(HOME)/.local/bin:$(PATH)

.PHONY: txt html clean

all: txt html

txt: target/draft.txt

html: target/draft.html

target/template.xml: template.xml
	@mkdir -p target
	cp template.xml $@

target/%.dbx: %.mkd transform.xsl
	@mkdir -p target
	pandoc $< -t docbook -s > $@

target/%.xml: target/%.dbx
	xsltproc transform.xsl $< > $@

%.txt: target/middle.xml target/back.xml target/template.xml
	cd target && xml2rfc template.xml --text --no-dtd -b draft

%.html: target/middle.xml target/back.xml target/template.xml
	cd target && xml2rfc template.xml --html --no-dtd -b draft

clean:
	rm -rf target 

