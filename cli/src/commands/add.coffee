#<< theoricus/generators/*

class theoricus.commands.Add
	{Model,Controller,View} =  theoricus.generators

	constructor:( @the, opts )->

		type = opts[1]
		name = opts[2]
		args = opts.slice 3

		unless @[type]?
			error_msg = "Valid options: controller, model, view, mvc."
			throw new Error error_msg

		@[type]( name, args )

	mvc:( name, args )->
		@model name.singularize(), args
		@view "#{name.singularize()}/index"
		@controller name

	model:( name, args )->
		new (Model)( @the, name, args )

	view:( path )->
		folder = (parts = path.split '/')[0]
		name   =  parts[1]

		unless name?
			error_msg = """
				Views should be added with path-style notation.\n
				\ti.e.:
				\t\t theoricus add view person/index
				\t\t theoricus add view user/list\n
			"""
			throw new Error error_msg
			return
		
		new (View)( @the, name, folder )

	controller:( name )->
		new Controller @the, name