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
  describe 'When calling theoricus on the cli', ->
    it "should be ok", (done) ->

      theo = spawn_theoricus []

      theo.stderr.on 'error', ( e ) -> done e

      theo.stdout.on 'data' , ( d ) -> done()

  describe 'When calling theoricus help on the cli', ->
    it "should be ok", (done) ->

      theo = spawn_theoricus ['help']

      theo.stderr.on 'error', ( e ) -> done e

      theo.stdout.on 'data' , ( d ) -> done()

  describe 'When calling theoricus start on the cli', ->
    it "should be ok", (done) ->

      theo = spawn_theoricus ['start']

      theo.stderr.on 'error', ( e ) -> done e

      theo.stdout.on 'data' , ( d ) -> done()