LIBDIR := lib
all:
	GEM_PATH=/usr/share/gems/:/usr/share/gems/gems/kramdown-1.17.0/lib/:/home/hardaker/.gem/ruby:/usr/share/gems:/usr/local/share/gems kramdown-rfc2629 draft-hardaker-dprive-add-doh-dnsop-filter-request.md

include $(LIBDIR)/main.mk


$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update $(CLONE_ARGS) --init
else
	git clone -q --depth 10 $(CLONE_ARGS) \
	    -b master git@github.com:martinthomson/i-d-template $(LIBDIR)
endif
