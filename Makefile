.PHONY: docs

THE=bin/the
POLVO=node_modules/polvo/bin/polvo

SELENIUM=tests/www/services/selenium-server-standalone-2.35.0.jar
SAUCE_CONNECT=tests/www/services/Sauce-Connect.jar
CHROME_DRIVER=tests/www/services/chromedriver

CS=node_modules/coffee-script/bin/coffee
MOCHA=node_modules/mocha/bin/mocha
COVERALLS=node_modules/coveralls/bin/coveralls.js

MVERSION=node_modules/.bin/mversion
VERSION=`$(MVERSION) | sed -E 's/\* package.json: //g'`

YUIDOC=node_modules/yuidocjs/lib/cli.js


# SETTTING UP DEV ENV
#-------------------------------------------------------------------------------

install_test_suite:
	@mkdir -p tests/www/services

	@echo '-----'
	@echo 'Downloading Selenium..'
	@curl -o tests/www/services/selenium-server-standalone-2.35.0.jar \
		https://selenium.googlecode.com/files/selenium-server-standalone-2.35.0.jar
	@echo 'Done.'

	@echo '-----'
	@echo 'Downloading Chrome Driver..'
	@curl -o tests/www/services/chromedriver.zip \
		https://chromedriver.googlecode.com/files/chromedriver_mac32_2.3.zip
	@echo 'Done.'
	
	@echo '-----'
	@echo 'Unzipping chromedriver..'
	@cd tests/www/services/; unzip chromedriver.zip; \
		rm chromedriver.zip; cd -
	@echo 'Done.'

	@echo '-----'
	@echo 'Downloading Sauce Connect..'
	@curl -o tests/www/services/sauceconnect.zip \
		http://saucelabs.com/downloads/Sauce-Connect-latest.zip
	
	@echo '-----'
	@echo 'Unzipping Sauce Connect..'
	@cd tests/www/services/; unzip sauceconnect.zip; \
		rm NOTICE.txt license.html sauceconnect.zip; cd -
	@echo '-----'
	@echo 'Done.'
	@echo 


setup: install_test_suite
	@echo '-----'
	npm link


# DEVELOPING
#-------------------------------------------------------------------------------

# watch / build
watch:
	$(CS) -wmco lib cli/src

build:
	$(CS) -mco lib cli/src


# GENERATING DOCS
#-------------------------------------------------------------------------------

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



# TESTS
#-------------------------------------------------------------------------------

# SELENIUM & SAUCE CONNECT
test.selenium.run:
	@java -jar $(SELENIUM) -Dwebdriver.chrome.driver=$(CHROME_DRIVER)

test.sauce.connect.run:
	@java -jar $(SAUCE_CONNECT) $(SAUCE_USERNAME) $(SAUCE_ACCESS_KEY)


# BUILDING TEST APP
test.build.prod:
	@echo 'Building app before testing..'
	@$(THE) -r --base tests/www/probatus > /dev/null

test.build.split:
	@echo 'Compiling app before testing..'
	@# @$(THE) -c --base tests/www/probatus > /dev/null
	@$(POLVO) -cxb tests/www/probatus > /dev/null


# TESTING LOCALLY
test: test.build.prod
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/tests/runner.coffee --env='local'

test.coverage: test.build.split
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
#   https://github.com/visionmedia/mocha/issues/937

test.saucelabs: test.build.prod
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/tests/runner.coffee --env='sauce labs'

test.saucelabs.coverage: test.build.split
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
#   https://github.com/admc/wd/blob/master/Makefile
ifdef TRAVIS
# secure env variables are not available for pull reuqests
# so you won't be able to run test against Sauce on these
ifneq ($(TRAVIS_PULL_REQUEST),false)
	@echo 'Skipping Sauce Labs tests as this is a pull request'
else
	@make test.saucelabs.coveralls
endif
else
	@make test.saucelabs.coveralls
endif


# MANAGING VERSIONS
#-------------------------------------------------------------------------------

bump.minor:
	@$(MVERSION) minor

bump.major:
	@$(MVERSION) major

bump.patch:
	@$(MVERSION) patch


# PUBLISHING / RE-PUBLISHING
#-------------------------------------------------------------------------------

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