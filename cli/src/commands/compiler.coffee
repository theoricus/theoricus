# requirements
path = require "path"
fs = require "fs"
cs = require "coffee-script"
nib = require "nib"
fsu = require 'fs-util'

jade = require "jade"
stylus = require "stylus"

Toaster = require 'coffee-toaster'
FnUtil = require 'coffee-toaster/src/toaster/utils/fn-util'
ArrayUtil = require 'coffee-toaster/src/toaster/utils/array-util'

module.exports = class Compiler

  BASE_DIR: ""
  APP_SRC: ""

  constructor:( @the, watch = false )->

    @BASE_DIR = @the.pwd
    @APP_SRC = "#{@BASE_DIR}/src/app"

    conf = @_read_build_conf()

    config = 
      dirs:[(path.join @BASE_DIR, 'src')]
      main: 'app/app'
      exclude: conf.exclude ? []
      release_dir: (path.join @BASE_DIR, 'public/js')
      bare: conf.bare ? true
      minify: conf.minify ? false
      optimize:
        base_url: conf.optimize.base_url ? ''
        vendors: conf.optimize.vendors ? {}

    # console.log '-------'
    # console.log conf
    # console.log '-------'

    # start watching/compiling coffeescript
    @toaster = new Toaster @BASE_DIR,
      w: watch
      c: !watch
      d:1
      config: config
    , true

    # The 'before_build' filter is called by Toaster everytime some file
    # changes. If this method returns TRUE, then toaster will build
    # everything automatically, otherwise if this method returns FALSE
    # user can call the build() method manually with some injection options.
    # Check the compile().
    @toaster.before_build = =>
      @compile()
      false

    # compiling everything at startup
    @compile()

    # watching jade and stylus
    return unless watch

    fsw_static = fsu.watch "#{@APP_SRC}/static", /(.jade|.styl)$/m
    fsw_static.on 'create', (FnUtil.proxy @_on_jade_stylus_change, 'create')
    fsw_static.on 'change', (FnUtil.proxy @_on_jade_stylus_change, 'change')
    fsw_static.on 'delete', (FnUtil.proxy @_on_jade_stylus_change, 'delete')

    fsw_config = fsu.watch "#{@BASE_DIR}/config", /(.coffee)$/m
    fsw_config.on 'change', (FnUtil.proxy @_on_jade_stylus_change, 'change')


  _on_jade_stylus_change:( ev, f )=>
    # skipe all folder creation
    return if f.type == "dir" and ev == "created"

    # date for CLI notifications
    now = ("#{new Date}".match /[0-9]{2}\:[0-9]{2}\:[0-9]{2}/)[0]

    # switch over created, deleted, updated and watching
    switch ev

      # when a new file is created
      when "create"
        msg = "New file created".bold.cyan
        console.log "[#{now}] #{msg} #{f.location}".green

      # when a file is deleted
      when "delete"
        type = if f.type == "file" then "File" else "Folder"
        msg = "#{type} deleted".bold.red
        console.log "[#{now}] {msg} #{f.location}".red

      # when a file is updated
      when "change"
        msg = "File changed".bold
        console.log "[#{now}] #{msg} #{f.location}".cyan

    # compile jade and/or coffee
    if ( f.location.match /.jade$/m  ) || ( f.location.match /.coffee$/m )
      @compile false

    # compile only stylus
    else if f.location.match /.styl$/m

      @compile_stylus ( css )=>
        target = "#{@the.pwd}/public/app.css"
        fs.writeFileSync target, css
        target = target.replace @BASE_DIR, ''
        target = target.substr 1 if target[0] is path.sep
        console.log "[#{now}] #{'Compiled'.bold} #{target}".green



  compile_jade:( after_compile )->
    files = fsu.find "#{@APP_SRC}/static", /.jade$/

    output = """(function() {
      app.templates = { ~TEMPLATES };
    }).call( this );"""

    buffer = []
    for file in files

      # skip files that starts with "_"
      continue if /^_/m.test (path.basename file)

      # compute template name and read file's source
      name = (file.match /static\/(.*).jade$/m)[1]
      source = fs.readFileSync file, "utf-8"

      # inject some virtual id's to be used by the model binding
      search = /#{([\w]+)}/g
      replace = '<!-- @$1 -->#{$1}<!-- /@$1 -->'
      source = source.replace search, replace

      # compile source
      # TODO: move compile options to config file
      compiled = jade.compile source,
        filename: file
        client: true
        compileDebug: false

      compiled = compiled.toString().replace "anonymous", ""

      definition = 'define( \'~name\', [], function(){return ~compiled});'
      definition = definition.replace '~compiled', (@to_single_line compiled)
      definition = definition.replace '~name', "app/templates/#{name}"
      
      release_file = "#{@the.pwd}/public/js/app/templates/#{name}.js"
      release_dir = path.dirname release_file

      fsu.mkdir_p release_dir unless (fs.existsSync release_dir)

      fs.writeFileSync release_file, definition
      
      # formatted time to CLI notifications
      now = ("#{new Date}".match /[0-9]{2}\:[0-9]{2}\:[0-9]{2}/)[0]
      release_dir = release_dir.replace @BASE_DIR, ''
      release_dir = release_dir.substr 1 if release_dir[0] is path.sep
      console.log "[#{now}] #{'✓ Compiled'.bold} #{release_dir}".green


  compile_stylus:( after_compile )->
    files = fsu.find "#{@APP_SRC}/static", /.styl$/
    
    buffer = []
    @pending_stylus = 0
    for file in files
      # skip files that starts with "_"
      @pending_stylus++ unless file.match( /(\_)?[^\/]+$/ )[1] is "_"
    
    for file in files

      # skip files that starts with "_"
      continue if file.match( /(\_)?[^\/]+$/ )[1] is "_"

      source = fs.readFileSync file, "utf-8"
      paths = [
        "#{@APP_SRC}/static/_mixins/stylus"
      ]

      # TODO: move compile options to config file
      stylus( source )
        .set( 'filename', file )
        .set( 'paths', paths )
        .use( nib() )
        .import( 'nib' )
        .render (err, css)=>
          throw err if err?
          buffer.push css
          if --@pending_stylus is 0
            after_compile( buffer.join "\n" ) 

  # updates the release files
  compile:( compile_stylus = true )->

    # build everything
    @toaster.build()

    # formatted time to CLI notifications
    now = ("#{new Date}".match /[0-9]{2}\:[0-9]{2}\:[0-9]{2}/)[0]

    # getting JADE templates pre-compiled
    @compile_jade()

    ###
    send message through socket.io asking browser to refresh
    ###
    # Server = Server
    
    # if Server.io?
    #   Server.io.sockets.emit( 'refresh', null );

    return unless compile_stylus

    # compile sytlus
    @compile_stylus ( css )=>
      target = "#{@the.pwd}/public/app.css"
      fs.writeFileSync target, css
      target = target.replace @BASE_DIR, ''
      target = target.substr 1 if target[0] is path.sep
      console.log "[#{now}] #{'✓ Compiled'.bold} #{target}".green


  _read_build_conf:()->
    build = "#{@the.pwd}/config/build.coffee"
    build = fs.readFileSync build, "utf-8"
    
    try
      tmp = {}
      build = cs.compile build.replace(/(^\w)/gm, "tmp.$1"), bare:1
      eval build
    catch error
      return throw error

    return tmp


  @to_single_line = @::to_single_line = ( code )->
    return code.replace /(^\/\/.*)|([\t\n]+)/gm, ""