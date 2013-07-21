wd = require 'wd'
fsu = require 'fs-util'
path = require 'path'
browsers = require './utils/browsers'

files = fsu.find (path.join __dirname, 'tests'), /\.coffee$/m

(require 'chai').Assertion.includeStack = true

exports.test = ( name, conf, base_url, mark_as_passed )->
  describe name, ->

    for file in files
      for browser_name, browser_conf of browsers

        # when testing local, ignores browsers that haven't the local prop set
        if name is 'local' 
          continue if not browser_conf.local

          browser_conf.platform = null
        
        # otherwise, skipe local_only configs
        else if browser_conf.local_only is true
          continue

        browser_conf.name = browser_name
        browser = if conf then wd.remote conf else do wd.remote
        test = (require file).test
        test browser, browser_conf, base_url, 60000, mark_as_passed