#<< theoricus/mvc/*
#<< theoricus/utils/string_util

class Factory
	controllers: {}
	StringUtil = theoricus.utils.StringUtil

	constructor:( @the )->
		@c_tmpl = "#{@the.boot.name}.controllers.{classname}Controller"
		@m_tmpl = "#{@the.boot.name}.models.{classname}Model"
		@v_tmpl = "#{@the.boot.name}.views.{ns}.{classname}View"
		@t_tmpl = "#{@the.boot.name}.views.{ns}.templates.{classname}Template"



	controller:( name )->
		# console.log "Factory.controller( '#{name}' )"
		name = StringUtil.camelize name
		if @controllers[ name ]?
			return @controllers[ name ]
		else
			controller = eval( @c_tmpl.replace( "{classname}", name ) )
			controller = new controller
			controller._boot @the
			@controllers[ name ] = controller



	model:( name )->
		# console.log "Factory.model( '#{name}' )"
		name = StringUtil.camelize name
		model = eval( @m_tmpl.replace "{classname}", name )
		model = new model
		model._boot @the



	view:( ns, name )->
		# console.log "Factory.view( '#{ns}', '#{name}' )"
		name = StringUtil.camelize name
		classpath = @v_tmpl.replace( "{ns}", ns ).replace( "{classname}", name )
		view = new ( eval classpath )
		view._boot @the


	template:( ns, name )->
		# console.log "Factory.template( '#{ns}', '#{name}' )"
		name = StringUtil.camelize name
		classpath = @t_tmpl.replace( "{ns}", ns ).replace( "{classname}", name )
		# console.log classpath
		new ( eval classpath )