should = do (require 'chai').should
colors = require 'colors'

{page_is_rendered} = require '../../utils/conditions'
quit = require '../../utils/quit'

exports.test = ( browser, browser_conf, base_url, timeout, mark_as_passed )->
  describe '★  testing title', ->

    describe 'using ' + browser_conf.name, ->

      # ------------------------------------------------------------------------
      # menu
      it 'wait until menu is visible', (done)->
        browser.init browser_conf, ->
          browser.get base_url, ->
            browser.waitForElementByClassName 'menu', timeout, ->
              browser.elementByClassName 'menu', (err, el)->
                should.not.exist err
                should.exist el
                done null
                console.log '\t---------------- /title/theoricus'.grey

      # ------------------------------------------------------------------------
      # /title/theoricus
      it 'click /title/theoricus link and check if redirect begun', (done)->
        browser.elementById 'title-theoricus', (err, el)->
          browser.clickElement el, ->
            browser.eval 'window.location.pathname', (err, pathname)->
              should.not.exist err
              should.exist pathname
              pathname.should.equal '/title/theoricus'
              done null

      it 'wait until page is rendered', (done)->
        browser.waitForCondition page_is_rendered, timeout, 30, (err, res)->
          should.not.exist err
          res.should.be.true
          done null

      it 'check if title is `Theoricus`', (done)->
        browser.title (err, title)->
          should.not.exist err
          should.exist title
          title.should.equal 'Theoricus'
          done null
          console.log '\t---------------- /title/is'.grey

      # ------------------------------------------------------------------------
      # /title/is
      it 'click /title/theoricus link and check if redirect begun', (done)->
        browser.elementById 'title-is', (err, el)->
          browser.clickElement el, ->
            browser.eval 'window.location.pathname', (err, pathname)->
              should.not.exist err
              should.exist pathname
              pathname.should.equal '/title/is'
              done null

      it 'wait until page is rendered', (done)->
        browser.waitForCondition page_is_rendered, timeout, 30, (err, res)->
          should.not.exist err
          res.should.be.true
          done null

      it 'check if title is `Theoricus`', (done)->
        browser.title (err, title)->
          should.not.exist err
          should.exist title
          title.should.equal 'Theoricus is'
          done null
          console.log '\t---------------- /title/is'.grey

      # ------------------------------------------------------------------------
      # /title/awesome
      it 'click /title/theoricus link and check if redirect begun', (done)->
        browser.elementById 'title-awesome', (err, el)->
          browser.clickElement el, ->
            browser.eval 'window.location.pathname', (err, pathname)->
              should.not.exist err
              should.exist pathname
              pathname.should.equal '/title/awesome'
              done null

      it 'wait until page is rendered', (done)->
        browser.waitForCondition page_is_rendered, timeout, 30, (err, res)->
          should.not.exist err
          res.should.be.true
          done null

      it 'check if title is `Theoricus`', (done)->
        browser.title (err, title)->
          should.not.exist err
          should.exist title
          title.should.equal 'Theoricus is awesome'
          quit browser, mark_as_passed, done