#<< theoricus/mvc/*

class theoricus.core.Factory
	controllers: {}

	constructor:( @the )->
		window.onbeforeunload = -> "CALMAE!"

	@model=@::model=( name, init = {} )->
		# console.log "Factory.model( '#{name}' )"

		classname = name.camelize()
		classpath = "app.models.#{name}"

		model = new (app.models[ classname ] )
		model.classpath = classpath
		model.classname = classname
		model[prop] = value for prop, value of init

		# console.log "----------------- MODEL"
		# console.log model
		# console.log "-----------------"

		model

	view:( path, el )->
		# console.log "Factory.view( '#{path}' )"

		klass = app.views
		classpath = "app.views"
		classname = (parts = path.split '/').pop().camelize()

		while parts.length
			classpath += "." + (p = parts.shift())
			klass = klass[p]

		klass = klass[classname]
		classpath += "." + classname

		view = new (klass)
		view._boot @the
		view.classpath = classpath
		view.classname = classname

		# console.log "----------------- VIEW"
		# console.log view
		# console.log "-----------------"

		view

	controller:( name )->
		# console.log "Factory.controller( '#{name}' )"

		classname = name.camelize()
		classpath = "app.models.#{classname}"

		if @controllers[ classname ]?
			return @controllers[ classname ]
		else
			controller = new (app.controllers[ classname ])
			controller.classpath = classpath
			controller.classname = classname
			controller._boot @the

			# console.log "----------------- CONTROLLER"
			# console.log controller
			# console.log "-----------------"

			@controllers[ classname ] = controller

	@template=@::template=( path )->
		# console.log "Factory.template( #{path} )"
		
		app.templates[path]