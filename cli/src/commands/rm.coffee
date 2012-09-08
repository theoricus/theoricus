class theoricus.commands.Rm
	fs = require 'fs'
	path = require 'path'

	{FsUtil} = ( require 'coffee-toaster' ).toaster.utils

	constructor:( @the, opts )->
		type = opts[1]
		name = opts[2]
		@recursive = opts[3]? and /\-\-rf/.test opts[3]

		@APP_FOLDER = "#{@the.pwd}/app"

		unless @[type]?
			error_msg = "Valid options: controller, model, view, mvc."
			throw new Error error_msg

		@[type]( name )

	mvc:( name )->
		@model name.singularize()
		@view "#{name.singularize()}/index"
		@controller name

	model:( name )->
		@rm "#{@APP_FOLDER}/models/#{name}.coffee"
		

	view:( path)->
		folder = (parts = path.split '/')[0]
		name = parts[1]

		unless (name? or @recursive)
			error_msg = """
				Views should be removed with path-style notation.\n
				\ti.e.:
				\t\t theoricus rm view person/index
				\t\t theoricus rm view user/list\n
			"""
			throw new Error error_msg
			return

		if @recursive
			@rm "#{@APP_FOLDER}/views/#{folder}"
			@rm "#{@APP_FOLDER}/static/#{folder}"
		else
			@rm "#{@APP_FOLDER}/views/#{folder}/#{name}.coffee"
			@rm "#{@APP_FOLDER}/static/#{folder}/#{name}.jade"
			@rm "#{@APP_FOLDER}/static/#{folder}/#{name}.styl"

	controller:( name, args, mvc = false )->
		@rm "#{@APP_FOLDER}/controllers/#{name}.coffee"


	rm:( filepath )->
		rpath = filepath.match /app\/.*/
		if fs.existsSync filepath
			try
				if fs.lstatSync( filepath ).isDirectory()
					if @recursive
						FsUtil.rmdir_rf filepath
					else
						fs.rmDirSync filepath
				else
					fs.unlinkSync filepath
			catch err
				throw new Error err
			console.log "#{'Removed'.bold} #{rpath}".red
		else
			console.log "#{'Not found'.bold} #{rpath}".yellow