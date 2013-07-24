should = do (require 'chai').should
quit = require './quit'

failures = 0
passed = no

exports.before = (browser, browser_conf, base_url, done)->

  browser.init browser_conf, (err)->
    console.log err if err?
    should.not.exist err
    browser.get base_url, (err)->
      console.log err if err?
      should.not.exist err
      do done

exports.after = (browser, mark_as_passed, done)->
  quit browser, mark_as_passed, (failures is 0), done

exports.beforeEach = ->
  passed = no

exports.afterEach = ->
  failures++ if not passed

exports.pass = (done)->
  passed = yes
  do done