#<< theoricus/utils/string_util

class Controller
	Factory = null
	StringUtil = theoricus.utils.StringUtil

	_boot:( @the )->
		Factory = @the.factory
		@
	
	_run:( @route, @after_run )->
		if @[ @route.api.action]?
			@[ @route.api.action ].apply @, @route.api.params
		else
			model = Factory.model @route.api.controller_name
			@render @route.api.action, model
	
	_destroy:( route, after_destroy )->
		route.view.after_out = after_destroy
		route.view.out =>
			$( route.view.el ).empty()
			route.view.after_out?()
	
	render:( view_name, data )->
		@route.view = Factory.view @route.api.controller_name, view_name
		@route.view.after_in = @after_run
		@route.view._render @route, view_name, data