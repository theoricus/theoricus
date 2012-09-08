class theoricus.generators.Controller
	fs = require 'fs'

	constructor:( @the, name )->
		template = "#{@the.root}/cli/src/generators/mvc/controller.coffee"
		filepath = "app/controllers/#{name}.coffee"

		name = name.camelize()
		model_name = name.singularize().camelize()
		model_lc = name.toLowerCase()

		template = fs.readFileSync template
		contents = template.replace /~NAME/g, name
		contents = contents.replace /~MODEL_CAMEL/g, model_name
		contents = contents.replace /~MODEL_LC/g, model_lc

		fs.writeFileSync filepath, contents
		console.log "#{'Created: '.bold} #{filepath}".green