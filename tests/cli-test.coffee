# ...
# requirements
fs     = require 'fs'
path   = require 'path'
{exec} = require 'child_process'

{spawn_theoricus,snapshot} = require "#{__dirname}/utils/utils"

# ...
# outputting version
version = fs.readFileSync (path.join __dirname, '../package.json'), 'utf-8'
console.log '\nCurrent version is: ' + (JSON.parse version).version

# ...
# defining global watcher var
base_path = path.join __dirname, 'tmp-tools'
fs.mkdirSync base_path, '0755'

describe '• Theoricus CLI', ->
  describe 'When calling theoricus', ->
    it "should be ok", (done) ->

      theo = spawn_theoricus []

      theo.stderr.on 'error', ( e ) -> done e

      theo.on 'exit' , ( d ) -> done()

  describe 'When calling theoricus help', ->
    it "should be ok", (done) ->

      theo = spawn_theoricus ['help']

      theo.stderr.on 'error', ( e ) -> done e

      theo.on 'exit' , ( d ) -> done()

  describe 'When calling theoricus compile', ->
    it "should be ok", (done) ->

      theo = spawn_theoricus ['compile']

      theo.stderr.on 'error', ( e ) -> done e

      theo.on 'exit' , ( d ) -> done()

  describe 'When calling theoricus index', ->
    it "should be ok", (done) ->

      theo = spawn_theoricus ['index']

      theo.stderr.on 'error', ( e ) -> done e

      theo.on 'exit' , ( d ) -> done()