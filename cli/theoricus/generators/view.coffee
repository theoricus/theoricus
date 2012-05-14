class View
	fs = require 'fs'

	template =
		body: "class ~NAMEView extends app.views.AppView"
		# actions: "home:( data )->\t@render 'home', new app.models.HomeModel

	constructor:( @the, opts )->
		name = opts[2]
		filepath = "app/views/" + name + "_view.coffee"

		contents = @build_contents name
		fs.writeFileSync filepath, contents
		console.log "#{'Created: '.bold} #{filepath}".green

		filepath = filepath.replace ".coffee", ".styl"
		fs.writeFileSync filepath, "// put your styles (stylus) here "
		console.log "#{'Created: '.bold} #{filepath}".green

		filepath = filepath.replace ".styl", ".jade"
		fs.writeFileSync filepath, "// put your tempalte(jade) here"
		console.log "#{'Created: '.bold} #{filepath}".green

	build_contents:( name )->
		buffer = ""
		buffer += template.body.replace "~NAME", name