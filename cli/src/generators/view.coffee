class theoricus.generators.View

	# requirements
	fs = require 'fs'
	toaster = (require 'coffee-toaster').toaster

	{FsUtil, StringUtil} = toaster.utils
	{Toaster} = toaster

	template =
		body: "class ~NAMEView extends app.views.AppView"
		# actions: "home:( data )->\t@render 'home', new app.models.HomeModel

	constructor:( @the, opts )->
		name = opts[2]

		view_path = "app/views/#{name}"
		static_path = "app/static/#{name}-index"

		view = "#{view_path}/index_view.coffee"
		jade = "#{static_path}/#{name}-index.jade"
		styl = "#{static_path}/#{name}-index.styl"

		# create contaioners
		FsUtil.mkdir_p view_path
		FsUtil.mkdir_p static_path

		# view
		fs.writeFileSync view, @build_contents( "index" )
		console.log "#{'Created: '.bold} #{view}".green

		# jade
		fs.writeFileSync jade, "//- put your templates (JADE) here "
		console.log "#{'Created: '.bold} #{jade}".green

		# stylus
		fs.writeFileSync styl, "// put your styles (STYLUS) here"
		console.log "#{'Created: '.bold} #{styl}".green

	build_contents:( name )->
		return template.body.replace "~NAME", StringUtil.ucasef name