class Rm
	fs = require 'fs'
	path = require 'path'

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
				@rm "app/views/#{name}_view.coffee"
				@rm "app/views/#{name}_view.styl"
				@rm "app/views/#{name}_view.jade"

			else
				console.log "ERROR: Valid options: controller,model,view,mvc."

	rm:( filepath )->
		if path.existsSync filepath
			fs.unlinkSync filepath
			console.log "#{'Removed:'.bold} #{filepath}".green
		else
			console.log "Not found: #{filepath}".yellow