request = require 'request'

user = null
key = null
build_id = process.env.TRAVIS_JOB_ID or (do new Date().getTime)

exports.config = (u, k)->
  [user, key] = [u, k]
  mark_as_passed

mark_as_passed = ( job_id, status, done) ->

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