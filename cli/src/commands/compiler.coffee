class theoricus.commands.Compiler

  # requirements
  path = require "path"
  fs = require "fs"
  nib = require "nib"
  fsu = require 'fs-util'

  jade = require "jade"
  stylus = require "stylus"

  Toaster = require( 'coffee-toaster' ).Toaster
  {FnUtil,ArrayUtil} = require( 'coffee-toaster' ).toaster.utils

  BASE_DIR: ""
  APP_FOLDER: ""

  constructor:( @the, watch = false )->

    @BASE_DIR = @the.pwd
    @APP_FOLDER = "#{@BASE_DIR}/app"

    config =
      folders: {}
      vendors:@_get_vendors()
      minify: false
      release: "public/app.js"
      debug: "public/app-debug.js"

    config.folders[@APP_FOLDER] = "app"

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

    fsw_static = fsu.watch "#{@APP_FOLDER}/static", /(.jade|.styl)$/m
    fsw_static.on 'create', (FnUtil.proxy @_on_jade_stylus_change, 'create')
    fsw_static.on 'change', (FnUtil.proxy @_on_jade_stylus_change, 'change')
    fsw_static.on 'delete', (FnUtil.proxy @_on_jade_stylus_change, 'delete')

    fsw_config = fsu.watch "#{@BASE_DIR}/config", /(.coffee)$/m
    fsw_config.on 'change', (FnUtil.proxy @_on_jade_stylus_change, 'change')

  _get_vendors:=>

    toaster_vendors = ["#{@the.root}/lib/theoricus.js"]

    # Vendors setted in app/config of theoricus app
    app_vendors = @_get_config().vendors

    for vendor, i in app_vendors
      # Get the absolute path of the vendor
      app_vendors[i] = path.join @the.pwd, 'vendors', vendor

    # Create new vendors array merging the toaster and theoricus vendors
    vendors = []
    vendors.push vendor for vendor in toaster_vendors
    vendors.push vendor for vendor in app_vendors

    vendors

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
        console.log "[#{now}] #{'Compiled'.bold} #{target}".green



  compile_jade:( after_compile )->
    files = fsu.find "#{@APP_FOLDER}/static", /.jade$/

    output = """(function() {
      app.templates = { ~TEMPLATES };
    }).call( this );"""

    buffer = []
    for file in files

      # skip files that starts with "_"
      continue if /^_/m.test file

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

      # write template name and contents
      compiled = compiled.toString().replace "anonymous", ""
      buffer.push "'#{name}': " + compiled

    # format everything
    output = output.replace( "~TEMPLATES", buffer.join "," )
    output = @to_single_line output

    # return all jade files compiled for use in client
    return "// TEMPLATES\n#{output}"


  compile_stylus:( after_compile )->
    files = fsu.find "#{@APP_FOLDER}/static", /.styl$/
    
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
        "#{@APP_FOLDER}/static/_mixins/stylus"
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
    # read conf
    conf = @_get_config()

    # getting JADE templates pre-compiled
    templates = @compile_jade()
      
    # merge everything
    header = """#{templates}\n
          #{conf.config}\n
          #{conf.routes}\n
          #{conf.root}\n"""
    
    # formats footer
    footer = ""

    # build everything
    @toaster.build header, footer

    # formatted time to CLI notifications
    now = ("#{new Date}".match /[0-9]{2}\:[0-9]{2}\:[0-9]{2}/)[0]

    ###
    send message through socket.io asking browser to refresh
    ###
    Server = theoricus.commands.Server
    
    if Server.io?
      Server.io.sockets.emit( 'refresh', null );

    return unless compile_stylus

    # compile sytlus
    @compile_stylus ( css )=>
      target = "#{@the.pwd}/public/app.css"
      fs.writeFileSync target, css
      console.log "[#{now}] #{'Compiled'.bold} #{target}".green


  _get_config:()->
    app    = "#{@the.pwd}/config/app.coffee"
    routes = "#{@the.pwd}/config/routes.coffee"

    app    = fs.readFileSync app, "utf-8"
    routes = fs.readFileSync routes, "utf-8"

    new theoricus.commands.Config app, routes

  to_single_line:( code )->
    theoricus.commands.Compiler.to_single_line code

  @to_single_line = ( code, ugli )->
    return code.replace /(^\/\/.*)|([\t\n]+)/gm, ""


class theoricus.commands.Config
  Compiler = theoricus.commands.Compiler

  fs = require "fs"
  cs = require "coffee-script"

  config: null
  routes: null
  root: null
  vendors:null

  constructor:( app, routes )->
    @_parse_app app
    @_parse_routes routes

  _parse_app:( app )->
    try
      tmp = {}
      app = cs.compile app.replace(/(^\w)/gm, "tmp.$1"), bare:1
      eval app
    catch error
      return throw error

    @vendors = tmp.vendors ? []

    # CONFIG
    @config = "// CONFIG\n" + Compiler.to_single_line """(function() {
      app.config = {
        animate_at_startup: #{tmp.animate_at_startup},
        enable_auto_transitions: #{tmp.enable_auto_transitions},
        vendors: ["#{tmp.vendors}"],
        autobind: #{tmp.autobind}
      };
    }).call( this );"""

  _parse_routes:( routes )->
    buffer = []
    root = null

    try
      tmp = {
        root:( route )-> root = route
        match:( route, options )->
          route = """'#{route}': {
            to: '#{options.to}',
            at: '#{options.at}',
            el: '#{options.el}'
          }"""
          buffer.push route.replace "'null'", null
      }
      routes = cs.compile routes.replace(/(^\w)/gm, "tmp.$1"), bare:1
      eval routes
    catch error
      return throw error

    # ROOT
    @root = "// ROOT\n" + Compiler.to_single_line """(function() {
      app.root = '#{root}';

    }).call( this );""", true

    # ROUTES
    @routes = "// ROUTES\n" + Compiler.to_single_line """(function() {
      app.routes = {
        #{buffer.join "," }
      };
    }).call( this );""", true
