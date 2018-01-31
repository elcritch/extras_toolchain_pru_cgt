SUBDIRS = src/lib/rpmsg_lib src/lib/pru_support_lib src/lib/msgpack_lib

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean:
	@for d in $(SUBDIRS); do (cd $$d; $(MAKE) clean ); done

.PHONY: $(SUBDIRS)
