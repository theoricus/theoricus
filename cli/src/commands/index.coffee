Compiler = require '../commands/compiler'

fork = (require 'child_process').fork

module.exports = class Index

  constructor:( @the, @cli )->
    process.on 'exit', =>
      do @compiler.polvo.kill
      do @snapshooter.kill

    @compiler = new Compiler @the, @cli, true, true
    @compiler.polvo.on 'message', (data)=>
      if data.channel is null and data.msg is 'server.started'
        do @start_snapshooter

  start_snapshooter:->
    console.log 'Start indexing pages..'.magenta
    snapshooter_path = path.join @the.root, 'node_modules', 'snapshooter'
    snapshooter_path = path.join snapshooter_path, 'bin', 'snapshooter'

    output = if (o = @cli.argv.index is true) then 'public_indexed' else o
    url = @cli.argv.url ? 'localhost:11235'
    opts = [ '-i', url, '-o', output]

    if @cli.argv.snapshooter?
      opts = opts.concat [].concat (@cli.argv.snapshooter.split ' ')

    @snapshooter = fork snapshooter_path, opts, cwd: @the.app_root
    @snapshooter.on 'exit', -> do process.exit