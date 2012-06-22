#<< theoricus/mvc/*
#<< theoricus/utils/string_util

class Factory
	controllers: {}
	StringUtil = theoricus.utils.StringUtil

	constructor:( @the )->
		app_name = @the.config.app_name
		@c_tmpl = "#{app_name}.controllers.{classname}Controller"
		@m_tmpl = "#{app_name}.models.{classname}Model"
		@v_tmpl = "#{app_name}.views.{ns}.{classname}View"
		@t_tmpl = "{ns}-{name}"

	controller:( name )->
		console.log "Factory.controller( '#{name}' )"
		name = StringUtil.camelize name
		if @controllers[ name ]?
			return @controllers[ name ]
		else
			classpath = @c_tmpl.replace "{classname}", name
			controller = eval classpath
			controller = new controller
			controller._boot @the
			@controllers[ name ] = controller

	model:( name )->
		# console.log "Factory.model( '#{name}' )"
		name = StringUtil.camelize name
		classpath = @m_tmpl.replace "{classname}", name
		model = eval classpath
		model = new model
		model._boot @the

	view:( ns, name )->
		# console.log "Factory.view( '#{ns}', '#{name}' )"
		name = StringUtil.camelize name
		classpath = @v_tmpl.replace( "{ns}", ns ).replace( "{classname}", name )
		view = eval classpath
		view = new view
		view._boot @the

	template:( ns, name )->
		path = @t_tmpl.replace( "{ns}", ns ).replace /\{name\}/g, name
		console.log "Factory.template( '#{path}' )"
		return app.templates[path]