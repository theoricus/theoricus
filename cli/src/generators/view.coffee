class View

	# requirements
	fs = require 'fs'

	FsUtil = ( require 'coffee-toaster' ).toaster.utils.FsUtil
	StringUtil = ( require 'coffee-toaster' ).toaster.utils.StringUtil
	Toaster = ( require 'coffee-toaster' ).Toaster

	template =
		body: "class ~NAMEView extends app.views.AppView"
		# actions: "home:( data )->\t@render 'home', new app.models.HomeModel

	constructor:( @the, opts )->
		name = opts[2]

		folderpath = "app/views/#{name}"
		view = "#{folderpath}/index_view.coffee"

		# create contaioner
		FsUtil.mkdir_p folderpath = "#{folderpath}/index"

		# compute paths
		jade = "#{folderpath}/index.jade"
		styl = "#{folderpath}/index.styl"

		# view
		fs.writeFileSync view, @build_contents( "index" )
		console.log "#{'Created: '.bold} #{view}".green

		# jade
		fs.writeFileSync jade, "// put your templates (JADE) here "
		console.log "#{'Created: '.bold} #{jade}".green

		# stylus
		fs.writeFileSync styl, "// put your styles (STYLUS) here"
		console.log "#{'Created: '.bold} #{styl}".green

	build_contents:( name )->
		return template.body.replace "~NAME", StringUtil.ucasef name