#<< theoricus/utils/string_util

class Controller
	Factory = null
	StringUtil = theoricus.utils.StringUtil

	_boot:( @the )->
		Factory = @the.factory
		@
	
	_run:( @route, params )->
		# if the action is defined, executes it
		if @[route.action]?
			@[route.action].apply @, params
		
		# otherwise tries to render based on the conventional nomenclature
		else
			@render @route.controller, Factory.model @route.controller
		# @route = false

	render:( view_name, data )->
		console.log "Controller.render( '#{view_name}', '#{data}' )"
		view = Factory.view @route.controller, view_name
		view.after_render = @after_run
		view.after_destroy = @after_destroy
		view._render @route, view_name, data