should = do (require 'chai').should
conds = require '../utils/conditions'

exports.test = ( browser, pass, timeout )->

  describe '[routes]', ->

    # menu
    # ------------------------------------------------------------------------
    describe '[menu must to exist]', ->
      it 'wait until menu is visible', (done)->
        browser.waitForElementByClassName 'menu', timeout, (err)->
          should.not.exist err
          browser.elementByClassName 'menu', (err, el)->
            should.not.exist err
            should.exist el
            pass done

    # /simple link
    # ------------------------------------------------------------------------
    describe '[simple route]', ->

      it 'click /simple link', (done)->
        browser.elementById 'routing-simple', (err, el)->
          should.not.exist err
          el.click (err)->
            should.not.exist err
            pass done

      it 'wait until page is rendered', (done)->
        browser.waitForCondition conds.is_rendered, timeout, 30, (err, res)->
          should.not.exist err
          res.should.be.true
          pass done

      it 'check if `simple-container` is available', (done)->
        browser.elementById 'simple-container', (err, el)->
          should.not.exist err
          should.exist el
          pass done

    # /deep link
    # ------------------------------------------------------------------------
    describe '[deep route]', ->
      it 'click /deep link', (done)->
        browser.elementById 'routing-deep', (err, el)->
          should.not.exist err
          el.click (err)->
            should.not.exist err
            pass done

      it 'wait until page is rendered', (done)->
        browser.waitForCondition conds.is_rendered, timeout, 30, (err, res)->
          should.not.exist err
          res.should.be.true
          pass done

      it 'check if `deep-param` is undefined', (done)->
        browser.elementById 'deep-param', (err, el)->
          should.not.exist err
          should.exist el
          el.text (err, text)->
            should.exist text
            text.should.equal 'undefined'
            pass done

      it 'check if `deep-container` is available', (done)->
        browser.elementById 'deep-container', (err, el)->
          should.not.exist err
          should.exist el
          pass done

    # /dynamic link
    # ------------------------------------------------------------------------
    describe '[dyanmic route without params]', ->
      it 'click /dynamic link', (done)->
        browser.elementById 'routing-dynamic', (err, el)->
          should.not.exist err
          el.click (err)->
            should.not.exist err
            pass done
      
      it 'wait until page is rendered', (done)->
        browser.waitForCondition conds.is_rendered, timeout, 30, (err, res)->
          should.not.exist err
          res.should.be.true
          pass done

      it 'assure /deep route\'s state remains untouched' , (done)->
        browser.eval '$("#deep-param").data("initial");', (err, status)->
          should.not.exist err
          status.should.be.true
          pass done

      it 'check if `dynamic-param` is undefined', (done)->
        browser.elementById 'dynamic-param', (err, el)->
          should.not.exist err
          should.exist el
          el.text (err, text)->
            should.exist text
            text.should.equal 'undefined'
            pass done

    # /dynamic/theoricus link
    # ------------------------------------------------------------------------
    describe '[dynamic route with params]', ->
      it 'click /dynamic/theoricus link', (done)->
        browser.elementById 'routing-dynamic-theoricus', (err, el)->
          should.not.exist err
          el.click (err)->
            should.not.exist err
            pass done

      it 'wait until page is rendered', (done)->
        browser.waitForCondition conds.is_rendered, timeout, 30, (err, res)->
          should.not.exist err
          res.should.be.true
          pass done

      it 'check if `deep-param` is theoricus', (done)->
        browser.elementById 'deep-param', (err, el)->
          should.not.exist err
          should.exist el
          el.text (err, text)->
            should.exist text
            text.should.equal 'theoricus'
            pass done

      it 'check /deep route\'s state to assure it has changed' , (done)->
        browser.eval '$("#deep-param").data("initial");', (err, status)->
          should.not.exist err
          should.not.equal status, true
          pass done

      it 'check if `dynamic-param` is theoricus', (done)->
        browser.elementById 'dynamic-param', (err, el)->
          should.not.exist err
          should.exist el
          el.text (err, text)->
            should.exist text
            text.should.equal 'theoricus'
            pass done