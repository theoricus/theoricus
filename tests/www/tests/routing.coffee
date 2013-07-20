should = do (require 'chai').should
quit = require '../utils/quit'

exports.test = ( browser, browser_conf, base_url, mark_as_passed )->
  describe 'using ' + browser_conf.name, =>
    describe 'routing simple url', =>
      it 'wait until link is visible', (done)=>
        browser.init browser_conf, =>
          browser.get base_url, =>
            browser.waitForVisibleById 'routing-simple', 2000, =>
              browser.elementById 'routing-simple', (err, @el)=>
                should.exist @el
                done null

      it 'then click it and waits for redirect', (done)=>
        browser.clickElement @el, =>
          browser.eval 'window.location.pathname', (err, pathname)=>
            should.exist pathname
            pathname.should.equal '/routing/simple'
            quit browser, mark_as_passed, done