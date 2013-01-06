# ...
# requirements
fs     = require 'fs'
path   = require 'path'

{spawn,snapshot} = require "#{__dirname}/utils/utils"

# static
APP_NAME = 'tmp-app'
APP_DIR  = path.join __dirname, APP_NAME

# ...
# outputting version
version = fs.readFileSync (path.join __dirname, '../package.json'), 'utf-8'
console.log '\nCurrent version is: ' + (JSON.parse version).version

cli = ( args ) -> spawn args, cwd: __dirname
app = ( args ) -> spawn args, cwd: APP_DIR

describe '• Theoricus CLI', ->
  describe 'When calling theoricus', ->

    it "should be ok", (done) ->

      theo = cli [""]

      theo.stderr.on 'error', ( e ) -> done e

      theo.on 'exit' , -> done()

  describe 'When calling theoricus new', ->
    it "should be ok", (done) ->

      theo = cli ['new', APP_NAME]

      theo.stderr.on 'error', ( e ) -> done e

      theo.on 'exit' , -> done()

    it "should create a folder #{APP_NAME}", (done) ->

      if fs.existsSync APP_DIR
        done()
      else
        done( "didn't create the folder" )