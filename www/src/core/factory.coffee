#<< theoricus/mvc/*
#<< theoricus/utils/string_util

class theoricus.core.Factory
	controllers: {}
	{StringUtil} = theoricus.utils

	constructor:( @the )->
		@m_tmpl = "app.models.{classname}Model"
		@v_tmpl = "app.views.{ns}.{classname}View"

	@model=@::model=( name, init = {} )->
		# console.log "Factory.model( '#{name}' )"
		classname = (StringUtil.camelize name) + 'Model'
		classpath = "app.models.#{name}"

		model = new (app.models[ classname ] )
		# model._boot @the
		model.classpath = classpath
		model.classname = classname
		model[prop] = value for prop, value of init
		model

	view:( path, el )->
		# console.log "Factory.view( '#{path}' )"
		classpath = "app.views"
		klass = app.views
		name = (parts = path.split '/').pop()

		while parts.length
			classpath += "." + (p = parts.shift())
			klass = klass[p]

		name = StringUtil.camelize name
		classpath += "." + (p = "#{name}View")
		klass = klass[p]

		view = new (klass)
		view._boot @the
		view.classpath = classpath
		view.classname = name
		view

	controller:( name )->
		# console.log "Factory.controller( '#{name}' )"
		classpath = "app.models"
		classname = StringUtil.camelize name
		if @controllers[ classname ]?
			return @controllers[ classname ]
		else
			controller = new (app.controllers[ "#{classname}Controller" ])
			controller.classpath = classpath
			controller.classname = classname
			controller._boot @the
			@controllers[ classname ] = controller

	@template=@::template=( path )->
		# console.log "Factory.template( #{path} )"
		return app.templates[path]