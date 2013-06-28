.PHONY: build docs

CS=node_modules/coffee-script/bin/coffee
YUIDOC=node_modules/yuidocjs/lib/cli.js

VERSION=`$(CS) build/bumper.coffee --version`


setup:
	npm link


# watch / build
watch:
	$(CS) -wmco lib cli/src

build:
	$(CS) -mco lib cli/src



# test
test: build
	# TODO: add testing routine



# docs generation
docs.www:
	cd www/src && \
	../../$(YUIDOC) \
	--syntaxtype coffee \
	-e .coffee \
	-o ../../docs/www \
	-t ../../docs/bootstrap-theme \
	-H ../../docs/bootstrap-theme/helpers/helpers.js \
	.

docs.www.server:
	cd www/src && \
	../../$(YUIDOC) \
	--syntaxtype coffee \
	-e .coffee \
	-o ../../docs/www \
	-t ../../docs/bootstrap-theme \
	-H ../../docs/bootstrap-theme/helpers/helpers.js \
	--server \
	.


# managing version
bump.minor:
	$(CS) build/bumper.coffee --minor

bump.major:
	$(CS) build/bumper.coffee --major

bump.patch:
	$(CS) build/bumper.coffee --patch



# publishing / re-publishing
publish:
	git tag $(VERSION)
	git push origin $(VERSION)
	git push origin master
	npm publish

re-publish:
	git tag -d $(VERSION)
	git tag $(VERSION)
	git push origin :$(VERSION)
	git push origin $(VERSION)
	git push origin master -f
	npm publish -f