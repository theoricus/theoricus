#<< theoricus/utils/string_util

class Controller
	Factory = null
	StringUtil = theoricus.utils.StringUtil

	_boot:( @the )->
		Factory = @the.factory
		@
	
	_run:( @route, @after_run )->
		# console.log "## CONTROLLER._run (+route, +after_run)"
		# console.log @route
		# console.log @after_run

		# if the action is defined, executes it
		if @[ @route.api.action]?
			# console.log "-> User defined ACTION!"
			@[ @route.api.action].apply @, @route.api.params
		# otherwise tries to render based on the conventional nomenclature
		else
			alias = @route.api.controller_name
			# console.log "-> Auto mode ACTION!" + alias
			model = Factory.model alias
			@render alias, model
	
	_destroy:( route, after_destroy )->
		# console.log "Controller._destroy" + after_destroy
		route.view.after_out = after_destroy
		route.view.out =>
			console.log "OUT COMPLETE"
			console.log @
			$( route.view.el ).empty()
			route.view.after_out?()
	
	# so called public methods
	render:( view_name, data )->
		# console.log "# CONTROLLER.render " + @after_render
		@route.view = Factory.view @route.api.controller_name, view_name
		# console.log @view
		@route.view.after_in = @after_run
		# console.log @view.after_in
		@route.view._render @route, view_name, data