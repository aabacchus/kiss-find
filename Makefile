PREFIX = /usr/local
CACHEDIR = $(HOME)/.cache
OUT = build
DB = $(OUT)/db.csv

all: $(DB)

clean:
	rm -f $(DB)

install: install-cli install-db

install-cli:
	mkdir -p        $(DESTDIR)$(PREFIX)/bin/
	cp kiss-find.sh $(DESTDIR)$(PREFIX)/bin/kiss-find

install-db: $(DB)
	mkdir -p $(DESTDIR)$(CACHEDIR)
	cp $(DB) $(DESTDIR)$(CACHEDIR)/

$(DB):
	mkdir -p $(OUT)
	src/db/list_repositories.sh | src/db/build_database.sh > $(DB)

.PHONY: all clean install install-cli install-db
