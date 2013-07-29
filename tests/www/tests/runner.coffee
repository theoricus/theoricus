wd = require 'wd'
fsu = require 'fs-util'
path = require 'path'

opt = (require 'optimist').argv
env = opt.env
coverage = opt.coverage

browsers = do (require './utils/browsers')[env]
hook = require './utils/hooks'
server = require './server'


# compute timeout notify_sauce_labs flag based on env
if env is 'local'
  timeout = 10000
  notify_sauce_labs = false
else
  timeout = 15000
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

# starts server
server.start coverage

# console.log 'testing'
# (require 'child_process').spawn 'curl', [
#   'http://localhost:8080/'
# ], stdio: 'inherit'

# mounting suites
# ------------------------------------------------------------------------------

# 1st root test suite - based on env
describe "[#{env}]", ->

  # loop through all browser configs
  for caps in browsers

    # computes session name based on the last two tags
    caps.name = (caps.tags.slice 1 ).join '_'

    # when testing local
    if env is 'local'

      # ignores platform and browser version
      caps.platform = null
      caps.version = null

    # 2nd root suite - based on browser
    describe "[#{caps.name}]", ->

      # INIT WD
      if env is 'local'
        browser = do wd.remote
      else
        browser = wd.remote sauce_conf
        console.log 'connecting using sauce credentials..'
        sauce_conf.pwd = sauce_conf.user = 'xxx'
        console.log sauce_conf

      # SET MOCHA HOOKS
      pass = hook @, browser, caps, base_url, notify_sauce_labs, coverage

      console.log 'caps', caps

      for file in files
        
        {test} = require file
        test browser, pass, timeout