path = require "path"
fork = require( "child_process" ).fork

module.exports = class Compiler

  constructor:( @the, @cli, release, webserver )->

    opts = ''
    opts += if release? then '-r' else '-c'
    opts += if webserver? then 's' else ''

    @polvo_path = path.join @the.root, 'node_modules', 'polvo', 'bin', 'polvo'
    fork @polvo_path, [opts], cwd: @the.app_root