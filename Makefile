SUBDIRS = src/lib/rpmsg src/lib/pru_support src/lib/msgpack

all: $(SUBDIRS)

priv_dir:
	mkdir -p priv/

$(SUBDIRS): priv_dir
	$(MAKE) -C $@

clean:
	@for d in $(SUBDIRS); do (cd $$d; $(MAKE) clean ); done

.PHONY: $(SUBDIRS)
