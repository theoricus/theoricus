wd = require 'wd'
fsu = require 'fs-util'
path = require 'path'

env = (require 'optimist').argv.env
browsers = do (require './utils/browsers')[env]
hook = require './utils/hooks'


# compute timeout, remote_conf and notify_sauce_labs flag based on env
if env is 'local'
  timeout = 1000
  # remote_conf = null
  notify_sauce_labs = false
else
  timeout = 3000
  remote_conf = sauce_conf
  notify_sauce_labs = true


# base url to test
base_url = "http://localhost:8080/"


# list of test files
files = fsu.find (path.join __dirname, 'functional'), /\.coffee$/m


# sauce connect config
sauce_conf = 
  hostname: 'localhost'
  port: 4445
  user: process.env.SAUCE_USERNAME
  pwd: process.env.SAUCE_ACCESS_KEY



# mounting suites
# ------------------------------------------------------------------------------

# 1st root test suite - based on env
describe "[#{env}]", ->

  # loop through all browser configs
  for browser_conf in browsers

    # when testing local
    if env is 'local'

      # ignores platform and browser version
      browser_conf.platform = null
      browser_conf.version = null


    # 2nd root suite - based on browser
    browser_name = (browser_conf.tags.slice 1 ).join '_'
    describe "[#{browser_name}]", ->

      # INIT WD
      browser = wd.remote remote_conf

      # SET MOCHA HOOKS
      pass = hook @, browser, browser_conf, base_url, notify_sauce_labs

      for file in files
        
        {test} = require file
        test browser, pass, timeout