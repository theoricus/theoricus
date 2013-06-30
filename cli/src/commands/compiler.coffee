path = require 'path'
fork = (require 'child_process' ).fork

module.exports = class Compiler

  constructor:( @the, @cli, release, webserver )->
    return unless do @the.is_theoricus_app

    opt = if release? then '-r' else '-c'

    polvo_path = path.join @the.root, 'node_modules', 'polvo', 'bin', 'polvo'
    @polvo = fork polvo_path, [opt], cwd: @the.app_root
    @polvo.on 'message', (data)=>
      switch data.channel
        when 'stdout' then console.log  data.msg
        when 'stderr' then console.error data.msg