all: draft-hardaker-dprive-add-doh-dnsop-filter-request.txt

draft-hardaker-dprive-add-doh-dnsop-filter-request.xml: draft-hardaker-dprive-add-doh-dnsop-filter-request.md
	kramdown-rfc2629 $< > $@

draft-hardaker-dprive-add-doh-dnsop-filter-request.txt: draft-hardaker-dprive-add-doh-dnsop-filter-request.xml
	xml2rfc --text -o $@ $<
