path = require 'path'
fork = (require 'child_process' ).fork

module.exports = class Compiler

  constructor:( @the, @cli, release, webserver )->
    return unless do @the.is_theoricus_app

    opt = if release? then '-r' else '-c'
    opt += if webserver? then 's' else ''

    @polvo_path = path.join @the.root, 'node_modules', 'polvo', 'bin', 'polvo'
    @polvo = fork @polvo_path, [opt, '--stdio'], cwd: @the.app_root
