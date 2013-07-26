should = do (require 'chai').should

module.exports = (browser, mark_as_passed, status, done)->
  browser.quit (err)->
    should.not.exist err
    return done null unless mark_as_passed
    mark_as_passed browser.sessionID, status, done