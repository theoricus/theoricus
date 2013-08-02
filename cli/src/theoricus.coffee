require('source-map-support').install handleUncaughtExceptions: false

fs = require "fs"
path = require "path"
colors = require 'colors'

require '../cli/vendors/inflection'

Generator = require './commands/generator'
NewProject = require './commands/new_project'
Destroyer = require './commands/destroyer'
Server = require './commands/server'
Compiler = require './commands/compiler'
Index = require './commands/index'

Cli = require './cli'

exports.run = ->
  new Theoricus

module.exports = class Theoricus
  
  constructor:->
    @cli = new Cli @version
    @version = (require "./../package.json" ).version

    @root = path.join __dirname, ".."
    @app_root = @_get_app_root()
    @pwd = @app_root || path.resolve "."

    return new NewProject @, @cli if @cli.argv.new
    return console.log @version if @cli.argv.version

    return new Generator @, @cli if @cli.argv.generate
    return new Destroyer @, @cli if @cli.argv.destroy
    return new Server @, @cli if @cli.argv.start
    return new Index @, @cli if @cli.argv.index
    return new Compiler @, @cli if @cli.argv.compile
    return new Compiler @, @cli, true if @cli.argv.release
    return new Compiler @, @cli, true, true if @cli.argv.preview

    console.log @cli.opts.help() + @cli.examples

  is_theoricus_app:->
    if @app_root == null
      console.log "ERROR".bold.red + " Not a Theoricus app."
      return false
    return true

  _get_app_root:()->
    current = path.resolve (@cli.argv.base or '.')

    while true
      app = path.join current, 'src', 'app', 'app.coffee'

      if fs.existsSync app
        contents = fs.readFileSync app, "utf-8"
        if contents.indexOf( 'extends Theoricus' ) > 0
          return current
        else
          return null
      else
        tmp = path.normalize (path.join current, '..')
        if current == tmp
          return null
        else
          current = tmp
          continue