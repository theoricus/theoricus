should = do (require 'chai').should
request = require 'request'

module.exports = (ctx, browser, browser_conf, base_url, notify_sauce_labs) ->

  passed = false
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
    browser.quit (err)->
      should.not.exist err
      
      if not notify_sauce_labs
        do done
      else
        do_notify_sauce_labs browser.sessionID, (failures is 0), done

  ctx.beforeEach ->
    passed = false

  ctx.afterEach ->
    failures++ if not passed

  pass = (done)->
    passed = true
    do done if done


user = process.env.SAUCE_USERNAME
key = process.env.SAUCE_ACCESS_KEY
build_id = process.env.TRAVIS_JOB_ID or (do new Date().getTime)

do_notify_sauce_labs = ( job_id, status, done) ->

  opts =
    url: "http://#{user}:#{key}@saucelabs.com/rest/v1/#{user}/jobs/#{job_id}"
    method: 'PUT'
    headers: 'Content-Type': 'text/json'
    body: JSON.stringify
      passed: status
      public: true
      build: build_id
    jar: false # disable cookies: avoids CSRF issues

  request opts, (err, res)-> done err