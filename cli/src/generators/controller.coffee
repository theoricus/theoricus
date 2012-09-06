class theoricus.generators.Controller
	fs = require 'fs'
	{StringUtil} = ( require 'coffee-toaster' ).toaster.utils

	template =
		body: """class ~NAME extends app.AppController
				~MODEL = app.models.~MODEL
			"""

	constructor:( @the, opts )->
		name = opts[2]
		filepath = "app/controllers/#{name}.coffee"

		contents = template.body.replace /~NAME/g, name.camelize()
		contents = contents.replace /~MODEL/g, name.singularize().camelize()

		fs.writeFileSync filepath, contents
		console.log "#{'Created: '.bold} #{filepath}".green