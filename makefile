.PHONY: docs

CS=node_modules/coffee-script/bin/coffee
MOCHA=node_modules/mocha/bin/mocha
VERSION=`$(CS) scripts/bumper.coffee --version`

setup:
	npm link
	@echo 'Downloading and unzipping selenium'

	@echo 'Downloading and unzipping chrome driver for selenium'


# watch / build
watch:
	$(CS) -wmco lib cli/src

build:
	$(CS) -mco lib cli/src



# docs generation
docs.cli:
	rm -rf docs-cli
	$(CODO) cli/src -o docs-cli --title Theoricus CLI Documentation
	cd docs-cli && python -m SimpleHTTPServer 8080

docs.www:
	rm -rf docs-www
	$(CODO) www/src -o docs-www --title Theoricus Documentation
	cd docs-www && python -m SimpleHTTPServer 8080



# local tests
test.start_selenium:
	@$(CS) tests/www/tasks/selenium.coffee --start


test.start_polvo_and_selenium:
	@$(CS) tests/www/tasks/all.coffee

test:
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 10000 \
	tests/www/run_local.coffee


# remote tests
test.start_sauce_connect:
	@java -jar tests/www/services/Sauce-Connect.jar $(SAUCE_USERNAME) $(SAUCE_ACCESS_KEY)

test.start_polvo:
	@$(CS) tests/www/tasks/polvo.coffee --start

test.stop_polvo:
	@$(CS) tests/www/tasks/polvo.coffee --stop

test_sauce_labs:
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 10000 \
	tests/www/run_sauce_labs.coffee



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