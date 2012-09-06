#<< theoricus/utils/string_util
#<< theoricus/mvc/model
#<< theoricus/mvc/view

class theoricus.mvc.Controller

	{Fetcher} = theoricus.mvc
	{StringUtil} = theoricus.utils
	{Model,View} = theoricus.mvc

	_boot:( @the )-> @

	_build_action:( process )->
		=>
			api = process.route.api
			[ctrl, action] = [api.controller_name, api.action_name]
			model_name = api.controller_name.singularize().camelize()
			model = app.models[model_name]

			if model.all?
				@render "#{ctrl}/#{action}", model.all()
			else
				@render "#{ctrl}/#{action}", null

	render:( path, data )->
		view = @the.factory.view path, @process.route.el
		view.process = @process
		view.after_in = view.process.after_run

		if data instanceof Fetcher
			if data.loaded
				view.render data.records
			else
				data.onload = ( records )->
					view.render records
		else
			view.render data

		view