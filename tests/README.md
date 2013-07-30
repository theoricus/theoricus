# Tests

This section will threat of the WWW tests (CLI tests is on progress).

The basic concept here is about:

1. A testable application codename `probatus`
2. Tests written on top of Selenium WebDriver, that mimics an user navigating through the pages


## Folder Structure

The basic folder structure is:
     
 * `/tests`
   * `/www`
     * `/probatus` sample app
     * `/services` pre-requiste files listed bellow
     * `/tests` all tests
         * `/functional` tests files, check them out to get the feeling!
         * `/utils` test utilities
     * `/coverage` tests coverage results

## Used Libraries

This setup involves this awesome libraries:

* [WD](https://github.com/admc/wd) - WebDriver / Selenium client for Node
* [Mocha](https://github.com/visionmedia/mocha) - Test Runner (using BDD)
* [Chai](https://github.com/chaijs/chai) - Test Assertions
* [Istanbul](https://github.com/gotwarlost/istanbul) - Coverage Instrumentation
* [Istanbul-Middleware](https://github.com/gotwarlost/istanbul-middleware) - Mind blowing coverage generation over WebDrive
* [Express](https://github.com/visionmedia/express) - Used to serve the `probatus` sample app withing the `istanbul-middleware`

## Used Services

Everything is set up to work with these awesome services:

 * [Travis CI](http://travis-ci.org) - For continuous integration
 * [Sauce Labs](http://saucelabs.com) - For cross-browser testing in the cloud
 * [Coveralls](http://coveralls.io) - Online coverage report tool
 

## Enough of talking

Let's cut to the chase.

# ★ Pre-requisites

<a name="files"/>
## 1. Files

> **HAPPY NOTE :)**<br/>
> If you're on OSX, you can simply run `make setup` and go right to item **[2. Browsers](#browsers)**, this command will download files, unzip them and put everything in the right place. But if you feel the need or if you are in other platforms, you may want continue reading.

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

<a name="browsers"/>
## 2. Browsers

The tests can ben run on whatever browser you want.

Locally (if you're on OSX) you'll probably be fine with four:
 * PhantomJS (for headless testing)
 * Firefox
 * Chrome
 * Safari

You can find the whole browser matrix in the file:

 * [`tests/www/tests/utils/browsers.coffee`](https://github.com/serpentem/theoricus/blob/master/tests/www/tests/utils/browsers.coffee)

You'll see two exports methods that returns an array of browsers configs:

````coffeescript
exports['local'] = ->
exports['sauce labs'] = ->
````

Obviously, the `local` is your local config. By default it will only run in `phantomjs` js. Uncomment others to test across multiple browsers at once.

The `sauce labs` is intended to run in the [Sauce Labs](http://saucelabs.com) grid, which provides vast combos of `browser` x `platforms`. Check it out:
> [https://saucelabs.com/docs/platforms](https://saucelabs.com/docs/platforms)

**Please** note that all possible and good combinations is already built in the `browsers.coffee` file, feel free to uncomment anything locally. Just do not push it back.


<a name="sauce-connect"/>
## 3. Sauce Connect

1. To run tests on Sauce Connect, first create an account:

[https://saucelabs.com/signup](https://saucelabs.com/signup)
> Remember that choosen `username` will be your public profile for testing `theoricus`. A good choice may be using `yourname-theoricus`, I don't know. Feel free.

1. Then add your credentials to your env:

````
export SAUCE_USERNAME=XXX
export SAUCE_ACCESS_KEY=YYY
````

> Worths to say, always run your tests locally to save some time. Running everything on sauce labs take much time, which you may want to avoid as much as possible.

# ★ Testing

## 1. Testing locally

Remember to link theoricus first (`npm link`)
> If you ran `make setup` you're already good to go.

Then open two terminal tabs:

### + Tab 1

Starting Selenium:

````
make test.selenium.run
````

### + Tab 2

Running tests:

````
make test
````

#### + Tab 2 (still)

To get coverage, instead of `make test` simply run:

````
make test.coverage
````

For previwing `LCOV-HTML` report right away, run with `preview`:


````
make test.coverage.preview
````

Then go to [http://localhost:8080](http://localhost:8080).


## 2. Testing on sauce labs

Open two terminal tabs:

### + Tab 1

Starting Sauce Connect:

````
make test.sauce.connect.run
````

### + Tab 2

Running tests:

````
make test.saucelabs
````
