wd = require 'wd'
fsu = require 'fs-util'
path = require 'path'

browsers = do (require './utils/browsers')
hook = require './utils/hooks'

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


exports.test = ( env )->

  # compute timeout, remote_conf and notify_sauce_labs flag based on env
  if env is 'local'
    timeout = 1000
    # remote_conf = null
    notify_sauce_labs = false
  else
    timeout = 3000
    remote_conf = sauce_conf
    notify_sauce_labs = true

  # 1st root test suite - based on env
  describe "[#{env}]", ->

    # loop through all browser configs
    for browser_conf in browsers

      # when testing local
      if env is 'local'

        # ignores browsers that haven't the local prop set
        continue if not browser_conf.local

        # and erases platform and browser version
        browser_conf.platform = null
        browser_conf.version = null

      # when testing at sauce labs, skip browsers set to run `local_only`
      else if browser_conf.local_only is true
        continue

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