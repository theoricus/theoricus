path = require 'path'
fork = (require 'child_process' ).fork

Generator = require '../commands/generator'
Destroyer = require '../commands/destroyer'
REPL = require '../repl/repl'


module.exports = class Server
  polvo: null
  repl: null

  constructor:( @the, options )->
    return unless do @the.is_theoricus_app

    process.on 'exit', => do @polvo.kill

    do @create_repl
    do @fork_polvo

  create_repl:->
    @repl = new REPL
    @repl.on 'generate', ( type, name )=> 
      new Generator @the, null, type, name, @repl
    @repl.on 'destroy', (type, name, options)=>
      new Destroyer @the, null, type, name, options, @repl

  fork_polvo:->
    polvo_path = path.join @the.root, 'node_modules', 'polvo', 'bin', 'polvo'
    @polvo = fork polvo_path, ['-ws'], cwd: @the.app_root

    @polvo.on 'message', (data)=>
      switch data.channel

        when 'stdout'
          if data.msg.stripColors isnt 'Initializing..'
            @repl.log data.msg
            if data.msg.indexOf('♫ ') is 0
              do @repl.start

        when 'stderr'
          @repl.error data.msg

    process.on 'SIGTERM', ->
      do @polvo.kill
      do process.exit