.PHONY: docs

CS=node_modules/coffee-script/bin/coffee
VERSION=`$(CS) scripts/bumper.coffee --version`

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
docs.cli:
	rm -rf docs-cli
	$(CODO) cli/src -o docs-cli --title Theoricus CLI Documentation
	cd docs-cli && python -m SimpleHTTPServer 8080

docs.www:
	rm -rf docs-www
	$(CODO) www/src -o docs-www --title Theoricus Documentation
	cd docs-www && python -m SimpleHTTPServer 8080



# managing version
bump.minor:
	$(CS) scripts/bumper.coffee --minor

bump.major:
	$(CS) scripts/bumper.coffee --major

bump.patch:
	$(CS) scripts/bumper.coffee --patch



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