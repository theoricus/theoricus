class Compiler

	# requirements
	path = require "path"
	fs = require "fs"

	jade = require "jade"
	stylus = require "stylus"

	Toaster = require( 'coffee-toaster' ).Toaster
	FsUtil = require( 'coffee-toaster' ).toaster.utils.FsUtil
	ArrayUtil = require( 'coffee-toaster' ).toaster.utils.ArrayUtil

	constructor:( @the, options )->
		config = {
			folders: {},
			vendors:[
				"#{@the.root}/vendors/jquery.js",
				"#{@the.root}/vendors/history.js",
				"#{@the.root}/vendors/history.adapter.native.js",
				"#{@the.root}/vendors/jade.runtime.js"
			],
			release: "public/app.js",
			debug: "public/app-debug.js"
		}

		config.folders["#{@the.pwd}/app"] = "app"
		config.folders["#{@the.root}/src"] = "theoricus"

		# start watching/compiling coffeescript
		@toaster = new Toaster @the.pwd, {w:1, d:1, config: config}, true

		# compiling everything at startup
		@compile()

		# watching jade
		FsUtil.watch_folder @the.pwd, /.jade$/m, ( info )=>
			@compile() if info.action != "watching"

		# watching stylus
		FsUtil.watch_folder @the.pwd, /.styl$/m, ( info )=>
			@compile() if info.action != "watching"

	
	compile_jade:( after_compile )->
		files = FsUtil.find @the.pwd, /.jade$/m

		output = """(function() {
			__t('app').templates = { ~TEMPLATES };
		}).call( this );"""

		buffer = []
		for file in files

			# skip files that starts with "_"
			continue if file.match( /(\_)?[^\/]+$/ )[1] is "_"

			# compute alias and read file's source
			alias = file.match( /views\/[^\.]+/ )[ 0 ]
			source = fs.readFileSync file, "utf-8"

			# compile source
			compiled = jade.compile source,
				filename: file
				client: true
				compileDebug: false

			# write template name and contents
			compiled = compiled.toString().replace "anonymous", ""
			buffer.push "'#{alias}': " + compiled

		# format everything
		output = output.replace( "~TEMPLATES", buffer.join "," )
		output = @to_single_line output

		# return all jade files compiled for use in client
		return "// TEMPLATES\n#{output}"

	
	compile_stylus:( after_compile )->
		files = FsUtil.find @the.pwd, /.styl$/m
		
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
				"#{@the.pwd}/app/views/_mixins/stylus"
			]

			stylus( source )
				.set( 'filename', file )
				.set( 'paths', paths )
				.render (err, css)=>
					throw err if err?
					buffer.push css
					if --@pending_stylus is 0
						after_compile( buffer.join "\n" ) 

	# updates the release files
	compile:()->
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
		footer = "new theoricus.Theoricus"

		# biulds all coffeescript
		@toaster.build header, footer

		# compile sytlus
		@compile_stylus ( css )=>
			target = "#{@the.pwd}/public/app.css"
			fs.writeFileSync target, css


	_get_config:()->
		app = "#{@the.pwd}/config/app.coffee"
		routes = "#{@the.pwd}/config/routes.coffee"

		app = fs.readFileSync app, "utf-8"
		routes = fs.readFileSync routes, "utf-8"

		new theoricus.commands.Config app, routes

	to_single_line:( code )->
		theoricus.commands.Compiler.to_single_line code

	@to_single_line = ( code, ugli )->
		return code.replace /(^\/\/.*)|([\t\n]+)/gm, ""


class Config
	Compiler = theoricus.commands.Compiler

	fs = require "fs"
	cs = require "coffee-script"

	config: null
	routes: null
	root: null

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

		# CONFIG
		@config = "// CONFIG\n" + Compiler.to_single_line """(function() {
			__t('app').config = {
				animate_at_startup: #{tmp.animate_at_startup},
				enable_auto_transitions: #{tmp.enable_auto_transitions}
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
			__t('app').root = '#{root}';

		}).call( this );""", true

		# ROUTES
		@routes = "// ROUTES\n" + Compiler.to_single_line """(function() {
			__t('app').routes = {
				#{buffer.join "," }
			};
		}).call( this );""", true