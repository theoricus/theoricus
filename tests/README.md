# Tests

The tests consists of:

1. A `testable` application
2. Tests written on top of Selenium WebDriver, that mimics an user navigating through the pages

Tough it may be slow, it tests exactly the current real features of all browsers.

It is a very apha version of this test suite, and may change in the future.

# ★ Pre-requisites

## 1. Files

Download and copy chromedriver, sauce-connect and selenium-server to the
`services` folder.

  1. Selenium
    * [https://code.google.com/p/selenium/downloads/list](https://code.google.com/p/selenium/downloads/list)
    	* If you're on osx, [this](https://code.google.com/p/selenium/downloads/detail?name=selenium-server-2.33.0.zip&can=2&q=) should take you to the right file.
  1. ChromeConnect
  	* [https://code.google.com/p/chromedriver/downloads/list](https://code.google.com/p/chromedriver/downloads/list)
    	* If you're on osx, [this](https://code.google.com/p/chromedriver/downloads/detail?name=chromedriver_mac_26.0.1383.0.zip&can=2&q=) should take you to the right file.
  1. Sauce Connect
  	* [https://saucelabs.com/docs/connect](https://saucelabs.com/docs/connect)
	  	* Regardles the platform, [this](http://saucelabs.com/downloads/Sauce-Connect-latest.zip) should take you to right file.

**The final structure should be exactly:**

  * /services
    * /chromedriver
    * /Sauce-Connect.jar
    * /selenium-server-standalone-2.33.0.jar

**Important:**

 1. Remember you must to have a JAVA environment.
 1. To assure you have, type `java` or `java -version` in your shell.

## 2. Browsers

To run tests locally in OSX, make sure you have Chrome, Firefox and Safari installed.

To run tests in other plataforms, adjust the browser list accordingly in file:

  * `tests/www/tests/utils/browsers`

## 3. Sauce Connect

1. To run tests on Sauce Connect, first create an account:
   * [https://saucelabs.com/signup](https://saucelabs.com/signup)
   > Remember that choosen `username` will be the profile for your tests.

1. Then add your credentials to your env:

````
export SAUCE_USERNAME=XXX
export SAUCE_ACCESS_KEY=YYY
````
> Worths to say, always run your tests locally to save some time. Running everything on sauce labs take much time, which you may want to avoid as much as possible.

# ★ Testing

## 1. Testing locally

Remember to link theoricus first (`npm link`)


### + Tab 1

````
make test.start_polvo_and_selenium
````

### + Tab 2

````
make test
````

## 2. Testing locally `while developing`

### + Tab 1

````
cd tests/www/probatus
the -s
````

### + Tab 2

````
make test.start_selenium
````

### + Tab 3

````
make test
````

## 3. Testing on sauce labs

### + Tab 1

````
make test.start_polvo
````

### + Tab 2

````
make test.start_sauce_connect
````

### + Tab 3

````
make test_sauce_labs
````