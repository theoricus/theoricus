class Processes
	active: {}	
	rendering: []
	
	constructor:( @the )->
		@factory = @the.factory
		@router = new theoricus.core.Router @the
		@router.on_change @process
		@router.init @the.boot.boot

	process:( route, params )=>
		controller = @factory.controller route.controller
		params = [].concat( params ).concat( route )

		controller.routing route
		controller[route.action].apply controller, params
		controller.routing false

		@active[ route.mask ] = route