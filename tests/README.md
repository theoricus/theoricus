# Pre-requisites

Download and copy chromedriver, sauce-connect and selenium-server to the
`services` folder.

The final structure should be:
  
  * /services
    * /chromedriver
    * /Sauce-Connect.jar
    * /selenium-server-standalone-2.33.0.jar

### Links

  * Selenium
    * [https://code.google.com/p/selenium/downloads/list](https://code.google.com/p/selenium/downloads/list)
    	* If you're on osx, [this](https://code.google.com/p/selenium/downloads/detail?name=selenium-server-2.33.0.zip&can=2&q=) should take you to the right file.
  * ChromeConnect
  	* [https://code.google.com/p/chromedriver/downloads/list](https://code.google.com/p/chromedriver/downloads/list)
    	* If you're on osx, [this](https://code.google.com/p/chromedriver/downloads/detail?name=chromedriver_mac_26.0.1383.0.zip&can=2&q=) should take you to the right file.
  * Sauce Connect
  	* [https://saucelabs.com/docs/connect](https://saucelabs.com/docs/connect)
	  	* Regardles the platform, [this](http://saucelabs.com/downloads/Sauce-Connect-latest.zip) should take you to right file.

# Testing locally

Remember to link theoricus first (`npm link`)

# Testing locally

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

## 2) Tab 3

````
make test
````

# Testing on Sauce Labs

## 1) Tab 1

````
make test.start_sauce_connect
````

## 2) Tab 2

````
make test.start_polvo
````

## 3) Tab 3

````
make test_sauce_labs
````

# NOTE

To run `make test_sauce` remember to first add your sauce username/accesskey in
available in your shell.

````
export SAUCE_USERNAME=YOUR-SAUCE-USERNAME
export SAUCE_ACCESS_KEY=YOUR-SAUCE-API-KEY
````