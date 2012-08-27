#<< theoricus/mvc/*
#<< theoricus/utils/string_util

class theoricus.core.Factory
	controllers: {}
	{StringUtil} = theoricus.utils

	constructor:( @the )->
		@m_tmpl = "app.models.{classname}Model"
		@v_tmpl = "app.views.{ns}.{classname}View"

	controller:( name )->
		# console.log "Factory.controller( '#{name}' )"
		name = StringUtil.camelize name
		if @controllers[ name ]?
			return @controllers[ name ]
		else
			controller = new (app.controllers[ "#{name}Controller" ])
			controller._boot @the
			@controllers[ name ] = controller

	model:( name, init = {} )->
		# console.log "Factory.model( '#{name}' )"

		name = StringUtil.camelize name
		model = new (app.models[ "#{name}Model" ])
		model._boot @the
		model[prop] = value for prop, value of init
		model

	view:( path )->
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
		view.classpath = classpath
		view._boot @the

	template:( path )->
		# console.log "Factory.template( #{path} )"
		return app.templates[path]