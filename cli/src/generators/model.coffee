class theoricus.generators.Model
	fs = require 'fs'

	constructor:( @the, name )->
		name_camel = name.camelize()
		name_lc = name.toLowerCase()
		controller_name_lc = name.pluralize().toLowerCase()

		tmpl = "#{@the.root}/cli/src/generators/templates/mvc/model.coffee"
		filepath = "app/models/#{name}.coffee"

		contents = (fs.readFileSync tmpl).toString()
		contents = contents.replace /~NAME_CAMEL/g, name_camel
		contents = contents.replace /~CONTROLLER_LC/g, controller_name_lc

		# write model
		unless fs.existsSync filepath
			fs.writeFileSync filepath, contents
			console.log "#{'Created'.bold} #{filepath}".green
		else
			console.log "#{'Already exists'.red.bold} #{filepath}".green