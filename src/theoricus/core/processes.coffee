#<< theoricus/utils/array_util
#<< theoricus/core/router

class Processes
	Factory = null
	ArrayUtil = theoricus.utils.ArrayUtil

	locked: false

	active_processes: []
	dead_processes: []
	pending_processes: []
	
	# --------------------------------------------------------------------------
	#	1. _on_router_change
	#	2. _filter_pending_processes
	#	3. _filter_dead_processes
	#	4. _destroy_dead_processes - one by one, waiting or not foll callback
	#		4.1 Timing can be sync/async
	#	5. _run - one by one, waiting or not foll callback
	#		5.1 timing can be sync/async
	# --------------------------------------------------------------------------

	constructor:( @the )->
		Factory = @the.factory
		@router = new theoricus.core.Router @the, @_on_router_change

	# 1
	_on_router_change:( route )=>
		return @router.navigate @last_route.location, false, true if @locked
		@last_route = route
		@locked = true
		@_filter_pending_processes route
		@_filter_dead_processes()
		@_destroy_dead_processes()

	# 2
	_filter_pending_processes:( route )->
		@pending_processes = [ route ]
		while true && route && route.target_route
			search = raw: route: route.target_route
			route = ArrayUtil.find @router.routes, search
			route = route.item if route?
			if route?
				@pending_processes.push route
				if route.target_route is null
					break

	# 3
	_filter_dead_processes:()->
		@dead_processes = []
		for route in @active_processes
			search = raw: route: route.raw.route
			found = ArrayUtil.find @pending_processes, search
			if found is null
				@dead_processes.push route

	# 4
	_destroy_dead_processes:()=>
		if @dead_processes.length
			route = @dead_processes.pop()
			search = raw: route: route.raw.route
			ArrayUtil.delete @active_processes, search
			route.destroy @_destroy_dead_processes
		else
			# console.log "All processes have benn, huh, destroyed."
			@_run_pending_processes()

	# 5
	_run_pending_processes:()=>
		if @pending_processes.length
			route = @pending_processes.pop()
			search = raw: route: route.raw.route
			unless ArrayUtil.find( @active_processes, search )?
				@active_processes.push route
				route.run @_run_pending_processes
			else
				@_run_pending_processes()
		else
			# console.log "All processes have benn, huh, processed."
			@locked = false