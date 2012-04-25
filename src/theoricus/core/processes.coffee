#<< theoricus/core/router

class Processes
	Factory = null

	active: {}	
	pending: []
	
	constructor:( @the )->
		Factory = @the.factory
		@router = new theoricus.core.Router @the
		@router.on_change @process
		@router.init @the.boot.boot



	process:( route, params )=>
		# console.log "Processes.process( '#{route.raw.route}' )"

		# if has no dependences
		if route.target_route is null or @is_rendered route.target_route
			@run route, params
		
		# otherwise if it has dependences
		else
			@pending.push {route:route, params:params}
			@router.run route.target_route

	is_rendered:( route )->
		@active[ route ]?

	run:( route, params )->
		controller = Factory.controller route.controller
		params = [].concat( params ).concat( route )

		controller.after_run = => @after_run()
		controller._run route, params
		@active[ route.raw.route ] = route



	after_run:()->
		if @pending.length
			item = @pending.pop()
			@router.run item.route.raw.route