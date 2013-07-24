should = do (require 'chai').should
colors = require 'colors'

conds = require '../../utils/conditions'
Hook = require '../../utils/hooks'


exports.test = ( browser, browser_conf, base_url, timeout, mark_as_passed )->

  describe 'testing title', ->

    describe 'using ' + browser_conf.name, ->

      # hooking mocha before/after methods to watch tests execution in order
      # to to see if some of them have failed, notifying sauce labs properly
      hook = new Hook browser, browser_conf, base_url, mark_as_passed
      
      before hook.before
      after hook.after
      beforeEach hook.beforeEach
      afterEach hook.afterEach
      
      pass = hook.pass


      # menu
      # ------------------------------------------------------------------------
      describe 'menu must to exist', ->
        it 'wait until menu is visible', (done)->
          browser.waitForElementByClassName 'menu', timeout, (err)->
            should.not.exist err
            browser.elementByClassName 'menu', (err, el)->
              should.not.exist err
              should.exist el
              do done

      # /title/theoricus
      # ------------------------------------------------------------------------
      describe 'link /title/theoricus', ->

        it 'click /title/theoricus link and check if redirect begun', (done)->
          browser.elementById 'title-theoricus', (err, el)->
            should.not.exist err
            el.click (err)->
              should.not.exist err
              do done

        it 'wait until page is rendered', (done)->
          browser.waitForCondition conds.is_rendered, timeout, 30, (err, res)->
            should.not.exist err
            res.should.be.true
            do done

        it 'check if title is `Theoricus`', (done)->
          browser.title (err, title)->
            should.not.exist err
            should.exist title
            title.should.equal 'Theoricus'
            do done

      # /title/is
      # ------------------------------------------------------------------------
      describe 'link /title/is', ->
        it 'click /title/is link and check if redirect begun', (done)->
          browser.elementById 'title-is', (err, el)->
            should.not.exist err
            el.click (err)->
              should.not.exist err
              do done

        it 'wait until page is rendered', (done)->
          browser.waitForCondition conds.is_rendered, timeout, 30, (err, res)->
            should.not.exist err
            res.should.be.true
            do done

        it 'check if title is `Theoricus`', (done)->
          browser.title (err, title)->
            should.not.exist err
            should.exist title
            title.should.equal 'Theoricus is'
            do done

      # /title/awesome
      # ------------------------------------------------------------------------
      describe 'link /title/awesome', ->
        it 'click /title/awesome link and check if redirect begun', (done)->
          browser.elementById 'title-awesome', (err, el)->
            el.click (err)->
              should.not.exist err
              do done

        it 'wait until page is rendered', (done)->
          browser.waitForCondition conds.is_rendered, timeout, 30, (err, res)->
            should.not.exist err
            res.should.be.true
            do done

        it 'check if title is `Theoricus`', (done)->
          browser.title (err, title)->
            should.not.exist err
            should.exist title
            title.should.equal 'Theoricus is awesome'
            do done