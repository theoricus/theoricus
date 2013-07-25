.PHONY: docs

THE=bin/the
SELENIUM=tests/www/services/selenium-server-standalone-2.33.0.jar
SAUCE_CONNECT=tests/www/services/Sauce-Connect.jar
CHROME_DRIVER=tests/www/services/chromedriver

CS=node_modules/coffee-script/bin/coffee
MOCHA=node_modules/mocha/bin/mocha
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


# APP RUNNERS
test.app.run:
	@$(THE) -p --base tests/www/probatus

test.app.run.bg:
	@$(THE) -p --base tests/www/probatus > tests/.probatus.log & \
		echo "$$!" > tests/.probatus.pid

test.app.kill.bg:
	@kill `cat .probatus.pid` && rm tests/.probatus.pid tests/.probatus.log


# TESTING LOCALLY
test:
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/run_local.coffee


# TESTING ON SAUCE LABS

# NOTE: The `--bail` option is hidden until Mocha fix the hooks execution
# 					https://github.com/visionmedia/mocha/issues/937

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
	tests/www/run_sauce_labs.coffee
endif
else
	@$(MOCHA) --compilers coffee:coffee-script \
	--ui bdd \
	--reporter spec \
	--timeout 600000 \
	tests/www/run_sauce_labs.coffee
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