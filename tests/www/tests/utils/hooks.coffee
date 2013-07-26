should = do (require 'chai').should
quit = require './quit'

module.exports = (ctx, browser, browser_conf, base_url, mark_as_passed) ->

  passed = false

  assertions = 0
  failures = 0

  ctx.beforeAll (done)->
    browser.init browser_conf, (err)->
      console.log err if err?
      should.not.exist err
      browser.get base_url, (err)->
        console.log err if err?
        should.not.exist err
        do done

  ctx.afterAll (done)->
    quit browser, mark_as_passed, (failures is 0), done

  ctx.beforeEach ->
    passed = false

  ctx.afterEach ->
    failures++ if not passed

  pass = (done) ->
    passed = true
    do done if done