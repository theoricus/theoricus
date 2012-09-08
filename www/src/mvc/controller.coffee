#<< theoricus/mvc/model
#<< theoricus/mvc/view

class theoricus.mvc.Controller

	{Fetcher} = theoricus.mvc
	{Model,View} = theoricus.mvc

	_boot:( @the )-> @

	_build_action:( process )->
		=>
			api = process.route.api

			model_name = api.controller_name.singularize().camelize()
			model = app.models[model_name]

			view_folder = api.controller_name.singularize()
			view_name = api.action_name

			if model.all?
				@render "#{view_folder}/#{view_name}", model.all()
			else
				@render "#{view_folder}/#{view_name}", null

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