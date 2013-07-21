# Pre-requisites

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

# Testing locally

Remember to link theoricus first (`npm link`)


## 1) Tab 1

````
make test.start_polvo_and_selenium
````

## 2) Tab 2

````
make test
````

# Testing locally `while developing`

## 1) Tab 1

````
cd tests/www/probatus
the -s
````

## 2) Tab 2

````
make test.start_selenium
````

## 3) Tab 3

````
make test
````

# Testing on sauce labs

## 1) Tab 1

````
make test.start_polvo
````

## 2) Tab 2

````
make test.start_sauce_connect
````

## 2) Tab 3

````
make test_sauce_labs
````