#<< theoricus/utils/array_util
#<< theoricus/core/router

class Processes
	Factory = null
	ArrayUtil = theoricus.utils.ArrayUtil

	deads: []
	active: []
	pendings: []
	
	constructor:( @the )->
		Factory = @the.factory
		@router = new theoricus.core.Router @the, @_on_router_change

	# execution order
	#	1. _on_router_change
	#	2. _filter_pending_processes
	#	3. _filter_dead_processes
	#	4. _destroy_dead_processes - one by one, waiting or not foll callback
	#		4.1 Timing can be sync/async
	#	5. _run - one by one, waiting or not foll callback
	#		5.1 timing can be sync/async

	# 1
	_on_router_change:( route )=>
		console.log "::::::::::::::::::::::::::::::::: ON CHANGE"
		console.log route

		@_filter_pending_processes route
		@_filter_dead_processes()
		@_filter_pending_processes route

		console.log "================= ACTIVES"
		console.log route for route in @active
		console.log "<<<"

		console.log "================= PENDINGS"
		console.log route for route in @pendings
		console.log "<<<"

		console.log "================= DEAD"
		console.log route for route in @deads
		console.log "<<<"

		@_destroy_dead_processes()

	# 2
	_filter_pending_processes:( route )->
		console.log "Processes._filter_pending_processes for:"
		console.log route

		@pendings = [ route ]
		while route.target_route?
			search = raw: route: route.target_route
			route = ArrayUtil.find @router.routes, search
			@pendings.push route.item if route?
			break unless route?

	# 3
	_filter_dead_processes:()->
		console.log "Processes._filter_dead_processes"
		
		@deads = []
		for route in @active
			console.log "$$$$$$$$$$$$ ACTIVE IS DEAD?"
			console.log route

			search = {raw: {route: route.raw.route}}
			console.log "@@@@ Search for #{route.raw.route} in pendings"
			found = ArrayUtil.find( @pendings, search )
			console.log found
			if found is null
				console.log "IS DEAD!"
				@deads.push route
			else
				console.log "NOT DEAD!"
				console.log route
				console.log "<<<"

	# 4
	_destroy_dead_processes:()=>
		console.log "Processes._destroy_dead_processes"
		
		if @deads.length
			route = @deads.pop()

			console.log "DESTROY=============================================" + @active.length
			console.log active for active in @active

			search = {raw: {route: route.raw.route}}
			ArrayUtil.delete @active, search

			console.log "DESTROYED=============================================" + @active.length
			console.log active for active in @active

			route.api.controller._destroy @_destroy_dead_processes
		else
			console.log "All processes have benn, huh, destroyed."
			@_run_pending_processes()

	# 5
	_run_pending_processes:()=>
		console.log "++++++++++++++++++++++++++++++++++++++"

		if @pendings.length
			route = @pendings.pop()
			console.log "Processes._run_pending_processes for:"
			console.log route
			search = {raw: route: route.raw.route}
			if ArrayUtil.find(@active, search) is null
				console.log "RENDER IT!"
				@active.push route
				route.api.controller._run route, @_run_pending_processes
			else
				console.log "ALREADY RENDERED!"
				@_run_pending_processes()
		else
			console.log "All processes have benn, huh, processed."