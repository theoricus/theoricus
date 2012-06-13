class Model
	fs = require 'fs'
	StringUtil = require( 'coffee-toaster' ).StringUtil

	template =
		body: "class ~NAMEModel extends app.models.AppModel"
		# actions: "home:( data )->\t@render 'home', new app.models.HomeModel

	constructor:( @the, opts )->
		name = opts[2]
		filepath = "app/models/" + name + "_model.coffee"

		contents = @build_contents name
		fs.writeFileSync filepath, contents
		console.log "#{'Created: '.bold} #{filepath}".green

	build_contents:( name )->
		buffer = ""
		buffer += template.body.replace "~NAME", StringUtil.ucasef name