should = do (require 'chai').should
quit = require './quit'


module.exports = class Hooks

  browser: null
  browser_conf: null
  base_url: null
  mark_as_passed: null

  failures: 0
  passed: no

  self = null

  constructor: (@browser, @browser_conf, @base_url, @mark_as_passed)->
    self = @

  before: (done)->
    self.browser.init self.browser_conf, (err)->
      console.log err if err?
      should.not.exist err
      self.browser.get self.base_url, (err)->
        console.log err if err?
        should.not.exist err
        do done

  after: (done)->
    quit self.browser, self.mark_as_passed, (self.failures is 0), done

  beforeEach: ->
    self.passed = no

  afterEach: ->
    self.failures++ if not self.passed

  pass: (done)->
    self.passed = yes
    do done