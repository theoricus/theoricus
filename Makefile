.PHONY: docs

THE=bin/the
SELENIUM=tests/www/services/selenium-server-standalone-2.33.0.jar
SAUCE_CONNECT=tests/www/services/Sauce-Connect.jar
CHROME_DRIVER=tests/www/services/chromedriver

CS=node_modules/coffee-script/bin/coffee
MOCHA=node_modules/mocha/bin/mocha
COVERALLS=node_modules/coveralls/bin/coveralls.js
VERSION=`$(CS) scripts/bumper.coffee --version`


#-------------------------------------------------------------------------------
# SETTTING UP DEV ENV

setup:
	npm link
	@echo 'Downloading and unzipping selenium'

	@echo 'Downloading and unzipping chrome driver for selenium'


#-------------------------------------------------------------------------------
# DEVELOPING

# watch / build
watch:
	$(CS) -wmco lib cli/src

build:
	$(CS) -mco lib cli/src


#-------------------------------------------------------------------------------
# GENERATING DOCS

docs:
	# to be merged


#-------------------------------------------------------------------------------
# TESTS

# SELENIUM & SAUCE CONNECT
test.selenium.run:
	@java -jar $(SELENIUM) -Dwebdriver.chrome.driver=$(CHROME_DRIVER)

test.sauce.connect.run:
	@java -jar $(SAUCE_CONNECT) $(SAUCE_USERNAME) $(SAUCE_ACCESS_KEY)


# BUILDING TEST APP
test.build.prod:
	@echo 'Building app before testing..'
	@$(THE) -r --base tests/www/probatus > /dev/null

test.build.dev:
	@echo 'Compiling app before testing..'
	@$(THE) -c --base tests/www/probatus > /dev/null


# TESTING LOCALLY
test: test.build.prod
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/tests/runner.coffee --env='local'

test.coverage: test.build.dev
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/tests/runner.coffee --env='local' --coverage

test.coveralls: test.coverage
	@sed -i.bak \
		"s/^.*public\/js\/theoricus/SF:theoricus/g" \
		tests/www/coverage/lcov.info

	@cd tests/www/probatus/public/js && \
		cat ../../../coverage/lcov.info | ../../../../../$(COVERALLS)
	
	@cd ../../../../../

test.coverage.preview: test.coverage
	@cd tests/www/coverage/lcov-report; python -m SimpleHTTPServer 8080; cd -


# TESTING ON SAUCE LABS

# NOTE: The `--bail` option is hidden until Mocha fix the hooks execution
# 	https://github.com/visionmedia/mocha/issues/937

test.saucelabs: test.build.prod
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/tests/runner.coffee --env='sauce labs'

test.saucelabs.coverage: test.build.dev
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/tests/runner.coffee --env='sauce labs' --coverage

test.saucelabs.coveralls: test.saucelabs.coverage
	@sed -i.bak \
		"s/^.*public\/js\/theoricus/SF:theoricus/g" \
		tests/www/coverage/lcov.info

	@cd tests/www/probatus/public/js && \
		cat ../../../coverage/lcov.info | ../../../../../$(COVERALLS)

	@cd ../../../../../

test.travis:
# Technique (skipping pull requests) borrowed from WD:
# 	https://github.com/admc/wd/blob/master/Makefile
ifdef TRAVIS
# secure env variables are not available for pull reuqests
# so you won't be able to run test against Sauce on these
ifneq ($(TRAVIS_PULL_REQUEST),false)
	@echo 'Skipping Sauce Labs tests as this is a pull request'
else
	@make test.saucelabs
endif
else
	@make test.saucelabs
endif


#-------------------------------------------------------------------------------
# MANAGING VERSIONS

bump.minor:
	$(CS) scripts/bumper.coffee --minor

bump.major:
	$(CS) scripts/bumper.coffee --major

bump.patch:
	$(CS) scripts/bumper.coffee --patch


#-------------------------------------------------------------------------------
# PUBLISHING / RE-PUBLISHING

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