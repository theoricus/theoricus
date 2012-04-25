#<< theoricus/mvc/*
#<< theoricus/utils/string_util

class Factory
	controllers: {}
	StringUtil = theoricus.utils.StringUtil

	constructor:( @the )->
		@c_tmpl = "#{@the.boot.name}.controllers.{classname}Controller"
		@m_tmpl = "#{@the.boot.name}.models.{classname}Model"
		@v_tmpl = "#{@the.boot.name}.views.{classname}View"
		@t_tmpl = "#{@the.boot.name}.views.templates.{classname}Template"



	controller:( name )->
		name = StringUtil.camelize name
		if @controllers[ name ]?
			return @controllers[ name ]
		else
			controller = eval( @c_tmpl.replace( "{classname}", name ) )
			controller = new controller
			@controllers[ name ] = controller.boot @the



	model:( name )->
		name = StringUtil.camelize name
		model = eval( @m_tmpl.replace "{classname}", name )
		model = new model
		model.boot @the



	view:( name )->
		name = StringUtil.camelize name
		view = eval( @v_tmpl.replace( "{classname}", name) )
		view = new view
		view.boot @the


	template:( name )->
		name = StringUtil.camelize name
		template = eval( @t_tmpl.replace( "{classname}", name) )
		new template