should = do (require 'chai').should
quit = require '../utils/quit'

exports.test = ( browser, browser_conf, base_url, mark_as_passed )->
  describe 'using ' + browser_conf.name, ->
    it 'title should be fetched', (done)->
      browser.init browser_conf, ->
        browser.get base_url, ->
          browser.title (err, title) ->
            title.should.equal 'Probatus'
            quit browser, mark_as_passed, done