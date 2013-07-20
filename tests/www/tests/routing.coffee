should = do (require 'chai').should
quit = require '../utils/quit'
colors = require 'colors'

exports.test = ( browser, browser_conf, base_url, mark_as_passed )->
  describe '★  testing routes', ->
    describe 'using ' + browser_conf.name, ->


      # ------------------------------------------------------------------------
      # menu
      it 'wait until menu is visible', (done)->
        browser.init browser_conf, ->
          browser.get base_url, ->
            browser.waitForElementByClassName 'menu', 2000, ->
              browser.elementByClassName 'menu', (err, el)->
                should.not.exist err
                should.exist el
                done null
                console.log '\t---------------- /simple'.grey

      # ------------------------------------------------------------------------
      # /simple link
      it 'click /simple link and check if redirect begun', (done)->
        browser.elementById 'routing-simple', (err, el)->
          browser.clickElement el, ->
            browser.eval 'window.location.pathname', (err, pathname)->
              should.not.exist err
              should.exist pathname
              pathname.should.equal '/routing/simple'
              done null

      it 'wait until page is rendered', (done)->
        browser.waitForCondition 'window.crawler.is_rendered == true;', (err, res)->
          should.not.exist err
          res.should.be.true
          done null

      it 'check if `simple-container` is available', (done)->
        browser.elementById 'simple-container', (err, el)->
          should.not.exist err
          should.exist el
          done null
          console.log '\t---------------- /deep'.grey

      # ------------------------------------------------------------------------
      # /deep link
      it 'click /deep link and check if redirect begun', (done)->
        browser.elementById 'routing-deep', (err, el)->
          el.click (err)->
            should.not.exist err
            browser.eval 'window.location.pathname', (err, pathname)->
              should.exist pathname
              pathname.should.equal '/routing/deep'
              done null

      it 'wait until page is rendered', (done)->
        browser.waitForCondition 'window.crawler.is_rendered == true;', 2000, 30, (err, res)->
          should.not.exist err
          res.should.be.true
          done null

      it 'check if `deep-param` is undefined', (done)->
        browser.elementById 'deep-param', (err, el)->
          should.not.exist err
          should.exist el
          el.text (err, text)->
            should.exist text
            text.should.equal 'undefined'
            done null

      it 'check if `deep-container` is available', (done)->
        browser.elementById 'deep-container', (err, el)->
          should.not.exist err
          should.exist el
          done null
          console.log '\t---------------- /dynamic'.grey

      # ------------------------------------------------------------------------
      # /dynamic link
      it 'click /dynamic link and check if redirect begun', (done)->
        browser.elementById 'routing-dynamic', (err, el)->
          el.click (err)->
            should.not.exist err
            browser.eval 'window.location.pathname', (err, pathname)->
              should.exist pathname
              pathname.should.equal '/routing/dynamic'
              done null
      
      it 'wait until page is rendered', (done)->
        browser.waitForCondition 'window.crawler.is_rendered == true;', 2000, 30, (err, res)->
          should.not.exist err
          res.should.be.true
          done null

      it 'check /deep route\'s state to assure it remains untouched' , (done)->
        browser.eval '$("#deep-param").data("initial");', (err, status)->
          should.not.exist err
          status.should.be.true
          done null

      it 'check if `dynamic-param` is undefined', (done)->
        browser.elementById 'dynamic-param', (err, el)->
          should.not.exist err
          should.exist el
          el.text (err, text)->
            should.exist text
            text.should.equal 'undefined'
            done null
            console.log '\t---------------- /dynamic/theoricus'.grey

      # ------------------------------------------------------------------------
      # /dynamic/theoricus link
      it 'click /dynamic/theoricus link and check if redirect begun', (done)->
        browser.elementById 'routing-dynamic-theoricus', (err, el)->
          el.click (err)->
            should.not.exist err
            browser.eval 'window.location.pathname', (err, pathname)->
              should.exist pathname
              pathname.should.equal '/routing/dynamic/theoricus'
              done null

      it 'wait until page is rendered', (done)->
        browser.waitForCondition 'window.crawler.is_rendered == true;', 2000, 30, (err, res)->
          should.not.exist err
          res.should.be.true
          done null

      it 'check if `deep-param` is theoricus', (done)->
        browser.elementById 'deep-param', (err, el)->
          should.not.exist err
          should.exist el
          el.text (err, text)->
            should.exist text
            text.should.equal 'theoricus'
            done null

      it 'check /deep route\'s state to assure it has changed' , (done)->
        browser.eval '$("#deep-param").data("initial");', (err, status)->
          should.not.exist err
          should.not.exist status
          done null

      it 'check if `dynamic-param` is theoricus', (done)->
        browser.elementById 'dynamic-param', (err, el)->
          should.not.exist err
          should.exist el
          el.text (err, text)->
            should.exist text
            text.should.equal 'theoricus'
            quit browser, mark_as_passed, done