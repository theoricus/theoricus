#<< theoricus/utils/string_util

class Controller
	Factory = null
	StringUtil = theoricus.utils.StringUtil

	boot:( @the )->
		Factory = @the.factory
		console.log "Controller.boot()"
		@
	
	render:( view, data )->
		view = Factory.view "main"
		view._render @route, data
	
	routing:( @route )->