class theoricus.commands.Rm
	fs = require 'fs'
	path = require 'path'

	FsUtil = ( require 'coffee-toaster' ).toaster.utils.FsUtil

	constructor:( @the, opts )->

		@kind = opts[1]
		@name = opts[2]
		@APP_FOLDER = "#{@the.pwd}/app"

		switch @kind
			when "controller" then @rm_controller()
			when "model" then @rm_model()
			when "view" then @rm_view()
			when "mvc"
				@rm_model()
				@rm_controller()
				@rm_view()
			else
				console.log "ERROR: Valid options: controller,model,view,mvc."

	rm_view:()->
		static_reg = new RegExp "#{@name}\-.*"
		views_reg = new RegExp "/#{@name}((/.*)|$)", "m"

		statics = FsUtil.find "#{@APP_FOLDER}/static/", static_reg, true
		views = FsUtil.find "#{@APP_FOLDER}/views", views_reg, true, true
		files = ( statics.reverse() ).concat( views.reverse() )

		@rm file for file in files

	rm_model:()->
		@rm "#{@APP_FOLDER}/models/#{@name}_model.coffee"

	rm_controller:()->
		@rm "#{@APP_FOLDER}/controllers/#{@name}_controller.coffee"

	rm:( filepath )->
		rpath = filepath.match /app\/.*/
		if path.existsSync filepath

			try
				if fs.lstatSync( filepath ).isDirectory()
					fs.rmdirSync filepath
				else
					fs.unlinkSync filepath
					is_file = true
			catch err
				if err.errno is -1
					console.log "#{'ERROR '.bold} Not empty: #{rpath}".yellow

			console.log "#{'Removed '.bold} #{rpath}".green if is_file