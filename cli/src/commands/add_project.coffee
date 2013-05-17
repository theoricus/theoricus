fs   = require 'fs'
path = require 'path'
pn   = path.normalize
exec = (require "child_process").exec
spawn = (require "child_process").spawn
fork = require( "child_process" ).fork

module.exports = class AddProject

  constructor:( @the, @cli )->

    if @cli.argv.new is true
      console.log "ERROR".bold.red + " You must specify a name for your project"
      return

    @pwd = @the.pwd
    @root = @the.root

    @app_skel = path.join @the.root, 'cli', 'templates', 'app_skel'
    @target   = path.join @pwd, @cli.argv.new

    if fs.existsSync @target

      console.log "ERROR".bold.red + " Target directory already existis."
      console.log "\t#{@target}".yellow
            
      return

    console.log '• Creating app skeleton'.grey
    cmd = "cp -r #{@app_skel} #{@target}"
    exec cmd, (error, stdout, stderr)=>
      return console.log error if error?
      do @configure


  configure:->
    name = @cli.argv.new

    # configurations when creating app from source
    if @cli.argv.src

      # will clone and initialize repo
      console.log '• Cloning theoricus source'.grey

      # config variables
      deps = ''
      the_www = 'vendors/theoricus/www'
      the_bin = 'vendors/theoricus/bin/the'

      # repo and branch
      repo = (@cli.argv.src.match /[^#]+/)[0]
      branch = (@cli.argv.src.match /#(.+)/)[1] or 'master'

      # cloning
      params = ['clone', "git@github.com:#{repo}", "vendors/theoricus"]
      options = cwd: @target, stdio: 'inherit'

      clone = spawn 'git', params, options
      clone.on 'close', ( code )=>
        return if code > 0

        # checking out proper branch
        params = ['checkout', repo]
        cwd = path.join @target, 'vendors', 'theoricus'
        options = cwd: cwd, stdio: 'inherit'

        checkout = spawn 'git', ['checkout', branch], options
        checkout.on 'close', ( code )=>
          return if code > 0
          
          # installing source dependencies
          install = spawn 'npm', ['install'], options
          install.on 'close', ( code )=>

            # proceed with creation of config files
            @write_config name, deps, the_www, the_bin

      return

    # default configuration
    deps = "\"theoricus\": \"#{@the.version}\""
    the_www = 'node_modules/theoricus/www'
    the_bin = 'node_modules/theoricus/bin/the'

    @write_config name, deps, the_www, the_bin

  
  write_config:( name, deps, the_www, the_bin )->

    # configures package.json
    pack = path.join @the.root, 'cli', 'templates', 'config', 'package.json'
    pack = fs.readFileSync pack, 'utf-8'
    pack = pack.replace '~name', @cli.argv.new
    pack = pack.replace '~deps', deps

    # configures polvo.coffee
    polvo = path.join @the.root, 'cli', 'templates', 'config', 'polvo.coffee'
    polvo = fs.readFileSync polvo, 'utf-8'
    polvo = polvo.replace '~theoricus-www', the_www

    # configures makefile
    make = path.join @the.root, 'cli', 'templates', 'config', 'makefile'
    make = fs.readFileSync make, 'utf-8'
    make = make.replace '~theoricus-bin', the_bin

    # write everything to disk
    fs.writeFileSync (path.join @target, 'package.json'), pack
    fs.writeFileSync (path.join @target, 'polvo.coffee'), polvo
    fs.writeFileSync (path.join @target, 'makefile'), make

    do @finish

  finish:->
    # install dependencies through a spawned `make setup` call
    console.log '• App created, setting up'.grey
    make = spawn 'make', ['setup'], {cwd: @target, stdio: 'inherit'}
    make.on 'close', (code)->
      return if code > 0

      console.log "\n\n★  Everything is ready!".cyan
      console.log "• Remember to add your app details in 'package.json'".grey
      console.log '• Have a nice job!\n'.green.grey