#<< theoricus/mvc/*

class theoricus.core.Factory

	{Model,View,Controller} = theoricus.mvc

	controllers: {}

	###
	@param [theoricus.Theoricus] @the   Shortcut for app's instance
	###
	constructor:( @the )->

	_is =( src, comparison )->
		while src = src.__proto__
			return true if src instanceof comparison
			src = src.__proto__
		return false

	@model=@::model=( name, init = {} )->
		# console.log "Factory.model( '#{name}' )"

		classname = name.camelize()
		classpath = "app.models.#{name}"

		unless (klass = app.models[ classname ])?
			throw new Error 'Model not found: ' + classpath

		unless (model = new (klass)) instanceof Model
			throw new Error 'Not a Model instance: ' + klass

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

		classpath += "." + classname

		unless (klass = klass[ classname ])?
			throw new Error 'View not found: ' + classpath

		unless (view = new (klass)) instanceof View
			throw new Error 'Not a View instance: ' + klass

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
		classpath = "app.controllers.#{classname}"

		if @controllers[ classname ]?
			return @controllers[ classname ]
		else

			unless (klass = app.controllers[ classname ])?
				throw new Error 'Controller not found: ' + classpath

			unless (controller = new (klass)) instanceof Controller
				throw new Error 'Not a Controller instance: ' + controller

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