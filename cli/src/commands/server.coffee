path = require 'path'
fork = require('child_process').fork
polvo = require 'polvo'

Generator = require '../commands/generator'
Destroyer = require '../commands/destroyer'
REPL = require '../repl/repl'

module.exports = class Server
  polvo: null
  repl: null

  constructor:( @the, options )->
    return unless @the.is_theoricus_app()

    process.on 'exit', => do @polvo.kill

    @create_repl()
    @fork_polvo()

    process.on 'SIGTERM', ->
      @polvo.kill()
      process.exit()

  create_repl:->
    @repl = new REPL
    @repl.on 'generate', ( type, name )=> 
      new Generator @the, null, type, name, @repl
    @repl.on 'destroy', (type, name, options)=>
      new Destroyer @the, null, type, name, options, @repl

  fork_polvo:->
    options = watch: true, server: true, base: @the.app_root
    @polvo = polvo options, out: @out, err: @err

  out:( msg )=>
    @repl.log msg
    if msg.stripColors.charAt(0) is '♫'
      @repl.start()

  err:( msg )=>
    @repl.error msg