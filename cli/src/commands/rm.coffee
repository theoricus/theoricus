class Rm
	fs = require 'fs'
	path = require 'path'

	FsUtil = require( "coffee-toaster" ).FsUtil

	constructor:( @the, opts )->

		action = opts[1]
		name = opts[2]

		switch action
			when "controller"
				@rm "app/controllers/#{name}_controller.coffee"

			when "model"
				@rm "app/models/#{name}_model.coffee"

			when "view"
				@rm "app/views/#{name}_view.coffee"

			when "mvc"
				@rm "app/controllers/#{name}_controller.coffee"
				@rm "app/models/#{name}_model.coffee"
				@rm null, "app/views/#{name}"
			else
				console.log "ERROR: Valid options: controller,model,view,mvc."

	rm:( filepath, folderpath )->
		if path.existsSync (target = filepath || folderpath)
			
			try
				if filepath?
					fs.unlinkSync filepath
				else if folderpath?
					FsUtil.rmdir_rf folderpath
			catch err
				throw err

			console.log "#{'Removed:'.bold} #{target}".green
		else
			console.log "Not found: #{filepath}".yellow