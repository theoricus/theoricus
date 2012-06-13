class Compiler

	# requirements
	path = require "path"
	fs = require "fs"

	jade = require "jade"
	stylus = require "stylus"

	Toaster = require( 'coffee-toaster' ).Toaster
	FsUtil = require( 'coffee-toaster' ).toaster.utils.FsUtil
	ArrayUtil = require( 'coffee-toaster' ).toaster.utils.ArrayUtil

	# global-private variable
	config = """
toast
	folders:
		'~APP': 'app'
		"~THE/src": 'theoricus'

	vendors: [
		"~THE/vendors/jquery.js"
		"~THE/vendors/history.js"
		"~THE/vendors/history.adapter.native.js"
		"~THE/vendors/jade.runtime.js"
	]

	release: 'public/app.js'
	debug: 'public/app-debug.js'
"""


	constructor:( @the, options, after_compile )->
		config_contents = config.replace /~THE/g, @the.root
		config_contents = config_contents.replace "~APP", "#{@the.pwd}/app"

		# watching coffeescript
		@toaster = new Toaster @the.pwd, config_contents, {w:1, d:1}, ()=>
			@compile =>
				after_compile?()
				after_compile = null
			return false

		# watching jade
		FsUtil.watch_folder @the.pwd, /.jade$/, ( info )=>
			@compile() if info.action != "watching"

		# watching stylus
		FsUtil.watch_folder @the.pwd, /.styl$/, ( info )=>
			@compile() if info.action != "watching"

	# compiling jade templates
	compile_jade:( after_compile )->

		FsUtil.find @the.pwd, "*.jade", ( files )=>
			output = """(function() {
				__t('app').templates = { ~TEMPLATES };
			}).call( this );"""
			buffer = []
			included = []

			for file in files

				# skip files that starts with "_"
				continue if file.match( /(\_)?[^\/]+$/ )[1] is "_"

				folder = file.split( "/" ).slice( 0, -1 ).join "/"
				alias = file.match( /views\/[^\.]+/ )[ 0 ]
				source = fs.readFileSync file, "utf-8"

				compiled = jade.compile source,
					filename: file
					client: true
					compileDebug: false

				compiled = compiled.toString().replace "anonymous", ""
				buffer.push "'#{alias}': " + compiled
 
			output = output.replace( "~TEMPLATES", buffer.join "," )
			output = @to_single_line output
			after_compile "// TEMPLATES\n#{output}"

	# compiling stylus styles
	compile_stylus:( after_compile )->
		FsUtil.find @the.pwd, "*.styl", ( files )=>
			buffer = []
			pending = 0

			for file in files

				# skip files that starts with "_"
				continue if file.match( /(\_)?[^\/]+$/ )[1] is "_"

				pending++
				source = fs.readFileSync file, "utf-8"
				paths = [
					"#{@the.pwd}/app/views/_mixins/stylus"
				]

				compiled = stylus( source )
							.set( 'filename', file )
							.set( 'paths', paths )
							.render (err, css)=>
								throw err if err?
								buffer.push css
								if --pending == 0
									after_compile( buffer.join "\n" )

	# updates the release files
	compile:( after_compile )->

		conf = @_get_config()

		# JADE
		@compile_jade ( templates )=>
			header = """#{templates}\n
						#{conf.config}\n
						#{conf.routes}\n
						#{conf.root}\n"""

			footer = "new theoricus.Theoricus"

			@toaster.build header, footer, =>
					# STYLUS
					@compile_stylus ( css )=>
						target = "#{@the.pwd}/public/app.css"
						fs.writeFileSync target, css
						after_compile?()

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