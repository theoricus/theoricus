#<< theoricus/utils/string_util

class Controller
	Factory = null
	StringUtil = theoricus.utils.StringUtil

	_boot:( @the )->
		Factory = @the.factory
		@
	
	_run:( @route, after_run )->
		console.log "Controller._run"

		# if the action is defined, executes it
		if @[ @route.api.action]?
			@[ @route.api.action].apply @, @route.api.params, after_run
			console.log "IF"
		# otherwise tries to render based on the conventional nomenclature
		else
			alias = @route.api.controller_name
			console.log "ELSE -> " + alias
			model = Factory.model alias
			@render alias, model, after_run
	
	_destroy:( after_destroy )->
		console.log "controller._destroy" + after_destroy
		@view.out =>
			$( @view.el ).empty()
			after_destroy?()
	
	# so called public methods
	render:( view_name, data, after_render )->
		# console.log "Controller.render( '#{view_name}', '#{data}' )"
		@view = Factory.view @route.api.controller_name, view_name
		@view.after_render = after_render
		@view._render @route, view_name, data