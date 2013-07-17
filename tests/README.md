# Pre-requisites

Download and copy chromedriver, sauce-connect and selenium-server to the
`services` folder.

The final structure should be:
  
  * /services
    * /chromedriver
    * /Sauce-Connect.jar
    * /selenium-server-standalone-2.33.0.jar

# Starting probatus (testable application)

Remember to link theoricus first (`npm link`)

````
cd probatus && the -s
````

# Testing locally

## 1) Tab 1

````
make test.start_polvo_and_selenium
````

## 2) Tab 2

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