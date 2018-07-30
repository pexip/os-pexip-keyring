build: pexip-archive-keyring.gpg pexip-archive-removed-keys.gpg

pexip-archive-keyring.gpg: active-keys/*.gpg
	cat $^ >$@
	gpg --no-options --no-default-keyring --no-auto-check-trustdb --no-keyring --import-options import-export --import < $@ >/dev/null
	gpg --no-options --no-default-keyring --no-auto-check-trustdb --no-keyring --list-packets <$@ | grep -q secret; test $$? = 1

pexip-archive-removed-keys.gpg: removed-keys/*.gpg
	cat $^ >$@
	gpg --no-options --no-default-keyring --no-auto-check-trustdb --no-keyring --import-options import-export --import < $@ >/dev/null
	gpg --no-options --no-default-keyring --no-auto-check-trustdb --no-keyring --list-packets <$@ | grep -q secret; test $$? = 1

clean:
	rm -f pexip-archive-keyring.gpg pexip-archive-removed-keys.gpg

install: build
	install -d $(DESTDIR)/usr/share/keyrings/
	install --mode=0644 pexip-archive-keyring.gpg $(DESTDIR)/usr/share/keyrings/
	install --mode=0644 pexip-archive-removed-keys.gpg $(DESTDIR)/usr/share/keyrings/
	install -d $(DESTDIR)/etc/apt/trusted.gpg.d/
	install --mode=0644 active-keys/*.gpg $(DESTDIR)/etc/apt/trusted.gpg.d/

.PHONY: build clean install
