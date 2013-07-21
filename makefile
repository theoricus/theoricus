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
	--timeout 600000 \
	--bail \
	tests/www/run_local.coffee


# remote tests
test.start_sauce_connect:
	@java -jar tests/www/services/Sauce-Connect.jar $(SAUCE_USERNAME) $(SAUCE_ACCESS_KEY)

test.start_polvo:
	$(CS) tests/www/tasks/polvo.coffee --start

test.start_polvo_in_bg:
	$(CS) tests/www/tasks/polvo.coffee --start > .tmp.polvo.log &

test.stop_polvo:
	@rm -rf .tmp.polvo.log
	@$(CS) tests/www/tasks/polvo.coffee --stop

test_sauce_labs:
# Technique (skipping pull requests) borrowed from WD:
# 	https://github.com/admc/wd/blob/master/Makefile
ifdef TRAVIS
# secure env variables are not available for pull reuqests
# so you won't be able to run test against Sauce on these
ifneq ($(TRAVIS_PULL_REQUEST),false)
	@echo 'Skipping Sauce Labs tests as this is a pull request'
else
		@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	--bail \
	tests/www/run_sauce_labs.coffee
endif
else
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	--bail \
	tests/www/run_sauce_labs.coffee
endif
	



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