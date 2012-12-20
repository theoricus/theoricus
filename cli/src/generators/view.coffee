class theoricus.generators.View

	fs = require 'fs'
	fsu = require 'fs-util'

	constructor:( @the, name, controller_name_lc, mvc = false )->
		name_camel = name.camelize()
		name_lc = name.toLowerCase()

		view_folder = "app/views/#{controller_name_lc}"
		static_folder = "app/static/#{controller_name_lc}"

		if mvc
			view_path = "#{view_folder}/index.coffee"
		else
			view_path = "#{view_folder}/#{name_lc}.coffee"

		jade_path = "#{static_folder}/index.jade"
		styl_path = "#{static_folder}/index.styl"

		# prepare contents
		tmpl_path = "#{@the.root}/cli/src/generators/templates/mvc"
		tmpl_view = "#{tmpl_path}/view.coffee"
		tmpl_jade = "#{tmpl_path}/view.jade"
		tmpl_styl = "#{tmpl_path}/view.styl"

		# create static container
		fsu.mkdir_p view_folder	
		fsu.mkdir_p static_folder

		# prepare view contents
		contents = (fs.readFileSync tmpl_view).toString()
		contents = contents.replace /~NAME_CAMEL/g, name_camel
		contents = contents.replace /~CONTROLLER_NAME_LC/g, controller_name_lc

		# write view
		fs.writeFileSync view_path, contents
		console.log "#{'Created'.bold} #{view_path}".green

		# write jade
		fs.writeFileSync jade_path, (fs.readFileSync tmpl_jade)
		console.log "#{'Created'.bold} #{jade_path}".green

		# write stylus
		fs.writeFileSync styl_path, fs.readFileSync tmpl_styl
		console.log "#{'Created'.bold} #{styl_path}".green