should = do (require 'chai').should

exports.test = ( browser, browser_conf, base_url, mark_as_passed )->
  describe 'using ' + browser_conf.name, ->
    it 'title should be fetched', (done)->
      browser.init browser_conf, ->
        browser.get base_url, ->
          browser.title (err, title) ->
            title.should.equal 'My Awesome App - made with Theoricus'
            browser.quit (err)->
              should.not.exist err
              return done null unless mark_as_passed
              mark_as_passed browser.sessionID, done