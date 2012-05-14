class Controller
	fs = require 'fs'

	template =
		body: "class ~NAMEController extends app.controllers.AppController"
		# actions: "home:( data )->\t@render 'home', new app.models.HomeModel

	constructor:( @the, opts )->
		name = opts[2]
		filepath = "app/controllers/" + name + "_controller.coffee"

		contents = @build_contents name
		fs.writeFileSync filepath, contents
		console.log "#{'Created: '.bold} #{filepath}".green

	build_contents:( name )->
		buffer = ""
		buffer += template.body.replace "~NAME", name