should = do (require 'chai').should
colors = require 'colors'

{page_is_rendered} = require '../../utils/conditions'
quit = require '../../utils/quit'

exports.test = ( browser, browser_conf, base_url, timeout, mark_as_passed )->

  describe 'testing routes', ->
    describe 'using ' + browser_conf.name, ->

      # ------------------------------------------------------------------------
      # menu
      describe 'menu must to exist', ->
        it 'wait until menu is visible', (done)->
          browser.init browser_conf, ->
            browser.get base_url, ->
              browser.waitForElementByClassName 'menu', timeout, (err)->
                should.not.exist err
                browser.elementByClassName 'menu', (err, el)->
                  should.not.exist err
                  should.exist el
                  do done

      # ------------------------------------------------------------------------
      # /simple link
      describe 'simple route', ->

        it 'click /simple link and check if redirect begun', (done)->
          browser.elementById 'routing-simple', (err, el)->
            should.not.exist err
            el.click (err)->
              should.not.exist err
              browser.eval 'window.location.pathname', (err, pathname)->
                should.not.exist err
                should.exist pathname
                pathname.should.equal '/routing/simple'
                do done

        it 'wait until page is rendered', (done)->
          browser.waitForCondition page_is_rendered, timeout, 30, (err, res)->
            should.not.exist err
            res.should.be.true
            do done

        it 'check if `simple-container` is available', (done)->
          browser.elementById 'simple-container', (err, el)->
            should.not.exist err
            should.exist el
            do done

      # ------------------------------------------------------------------------
      # /deep link
      describe 'deep route', ->
        it 'click /deep link and check if redirect begun', (done)->
          browser.elementById 'routing-deep', (err, el)->
            should.not.exist err
            el.click (err)->
              should.not.exist err
              browser.eval 'window.location.pathname', (err, pathname)->
                should.exist pathname
                pathname.should.equal '/routing/deep'
                do done

        it 'wait until page is rendered', (done)->
          browser.waitForCondition page_is_rendered, timeout, 30, (err, res)->
            should.not.exist err
            res.should.be.true
            do done

        it 'check if `deep-param` is undefined', (done)->
          browser.elementById 'deep-param', (err, el)->
            should.not.exist err
            should.exist el
            el.text (err, text)->
              should.exist text
              text.should.equal 'undefined'
              do done

        it 'check if `deep-container` is available', (done)->
          browser.elementById 'deep-container', (err, el)->
            should.not.exist err
            should.exist el
            do done

      # ------------------------------------------------------------------------
      # /dynamic link
      describe 'dyanmic route without params', ->
        it 'click /dynamic link and check if redirect begun', (done)->
          browser.elementById 'routing-dynamic', (err, el)->
            should.not.exist err
            el.click (err)->
              should.not.exist err
              browser.eval 'window.location.pathname', (err, pathname)->
                should.exist pathname
                pathname.should.equal '/routing/dynamic'
                do done
        
        it 'wait until page is rendered', (done)->
          browser.waitForCondition page_is_rendered, timeout, 30, (err, res)->
            should.not.exist err
            res.should.be.true
            do done

        it 'check /deep route\'s state to assure it remains untouched' , (done)->
          browser.eval '$("#deep-param").data("initial");', (err, status)->
            should.not.exist err
            status.should.be.true
            do done

        it 'check if `dynamic-param` is undefined', (done)->
          browser.elementById 'dynamic-param', (err, el)->
            should.not.exist err
            should.exist el
            el.text (err, text)->
              should.exist text
              text.should.equal 'undefined'
              do done

      # ------------------------------------------------------------------------
      # /dynamic/theoricus link
      describe 'dynamic route with params', ->
        it 'click /dynamic/theoricus link and check if redirect begun', (done)->
          browser.elementById 'routing-dynamic-theoricus', (err, el)->
            should.not.exist err
            el.click (err)->
              should.not.exist err
              browser.eval 'window.location.pathname', (err, pathname)->
                should.exist pathname
                pathname.should.equal '/routing/dynamic/theoricus'
                do done

        it 'wait until page is rendered', (done)->
          browser.waitForCondition page_is_rendered, timeout, 30, (err, res)->
            should.not.exist err
            res.should.be.true
            do done

        it 'check if `deep-param` is theoricus', (done)->
          browser.elementById 'deep-param', (err, el)->
            should.not.exist err
            should.exist el
            el.text (err, text)->
              should.exist text
              text.should.equal 'theoricus'
              do done

        it 'check /deep route\'s state to assure it has changed' , (done)->
          browser.eval '$("#deep-param").data("initial");', (err, status)->
            should.not.exist err
            should.not.equal true
            do done

        it 'check if `dynamic-param` is theoricus', (done)->
          browser.elementById 'dynamic-param', (err, el)->
            should.not.exist err
            should.exist el
            el.text (err, text)->
              should.exist text
              text.should.equal 'theoricus'
              quit browser, mark_as_passed, done