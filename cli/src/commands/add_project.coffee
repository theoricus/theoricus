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
    src = @cli.argv.src

    # configurations when creating app from source
    if src

      # repo and branch infos
      repo = null
      branch = null

      # default repo name = theoricus
      repo = (src.match /[^#]+/)[0]

      unless ~src.indexOf '/'
        repo += '/theoricus'

      repo = "git@github.com:#{repo}"

      # default branch = master
      if ~src.indexOf '#'
        branch = (@cli.argv.src.match /#(.+)/)[1]
      else
        branch = 'master'

      # if git submodule is avoided, clone as a clean repo
      if @cli.argv.nogitsub
        @clone name, repo, branch

      # otherwise add it as submodule
      else
        @add_as_submodule name, repo, branch

    # otherwise if new app isn't being created from source
    else
      # default configuration
      deps = "\"theoricus\": \"#{@the.version}\""
      the_www = 'node_modules/theoricus/www'

      @write_config name, deps, the_www

  clone:( name, repo, branch )->
    # will clone and initialize repo
    console.log '• Cloning theoricus source'.grey

    # config variables
    deps = ''
    the_www = 'vendors/theoricus/www'

    # cloning
    params = ['clone', repo, 'vendors/theoricus']
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
          @write_config name, deps, the_www

  add_as_submodule:( name, repo, branch )->
    # will clone and initialize repo
    console.log '• Cloning theoricus source as submodule'.grey

    # config variables
    deps = ''
    the_www = 'vendors/theoricus/www'

    # git init
    init = spawn 'git', ['init'], {cwd: @target, stdio: 'inherit'}
    init.on 'close', ( code )=>
      return if code > 0

      # adding as submodule
      params = ['submodule', 'add', repo, 'vendors/theoricus']
      options = cwd: @target, stdio: 'inherit'

      clone = spawn 'git', params, options
      clone.on 'close', ( code )=>
        return if code > 0

        # checking out proper branch
        params = ['checkout', branch]
        cwd = path.join @target, 'vendors', 'theoricus'
        options = cwd: cwd, stdio: 'inherit'

        checkout = spawn 'git', params, options
        checkout.on 'close', ( code )=>
          return if code > 0
          
          # installing source dependencies
          install = spawn 'npm', ['install'], options
          install.on 'close', ( code )=>

            # proceed with creation of config files
            @write_config name, deps, the_www

  write_config:( name, deps, the_www )->
    console.log 'write ' + [name, deps, the_www]
    # configures package.json
    pack = path.join @the.root, 'cli', 'templates', 'config', 'package.json'
    pack = fs.readFileSync pack, 'utf-8'
    pack = pack.replace '~name', name
    pack = pack.replace '~deps', deps

    # configures polvo.coffee
    polvo = path.join @the.root, 'cli', 'templates', 'config', 'polvo.coffee'
    polvo = fs.readFileSync polvo, 'utf-8'
    polvo = polvo.replace '~theoricus-www', the_www

    # write everything to disk
    fs.writeFileSync (path.join @target, 'package.json'), pack
    fs.writeFileSync (path.join @target, 'polvo.coffee'), polvo

    do @finish

  finish:->
    # install dependencies through a spawned `npm install` call
    console.log '• App created, setting up'.grey
    make = spawn 'npm', ['install'], {cwd: @target, stdio: 'inherit'}
    make.on 'close', (code)->
      return if code > 0

      console.log "\n\n★  Everything is ready!".cyan
      console.log "• Remember to add your app details in 'package.json'".grey
      console.log '• Have a nice job!\n'.green.grey