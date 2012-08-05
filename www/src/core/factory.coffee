#<< theoricus/mvc/*
#<< theoricus/utils/string_util

class theoricus.core.Factory
	controllers: {}
	StringUtil = theoricus.utils.StringUtil

	constructor:( @the )->
		@m_tmpl = "app.models.{classname}Model"
		@v_tmpl = "app.views.{ns}.{classname}View"
		@t_tmpl = "{ns}-{name}"

	controller:( name )->
		# console.log "Factory.controller( '#{name}' )"
		name = StringUtil.camelize name
		if @controllers[ name ]?
			return @controllers[ name ]
		else
			controller = new (app.controllers[ "#{name}Controller" ])
			controller._boot @the
			@controllers[ name ] = controller

	model:( name )->
		# console.log "Factory.model( '#{name}' )"
		name = StringUtil.camelize name
		model = new (app.models[ "#{name}Model" ])
		model._boot @the

	view:( ns, name )->
		# console.log "Factory.view( '#{ns}', '#{name}' )"
		name = StringUtil.camelize name
		view = new (app.views[ns]["#{name}View"])
		view._boot @the

	template:( ns, name )->
		# console.log "Factory.template( ns, name )"
		return app.templates["#{ns}-#{name}"]