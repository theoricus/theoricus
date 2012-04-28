#<< theoricus/utils/array_util
#<< theoricus/core/router

class Processes
	Factory = null
	ArrayUtil = theoricus.utils.ArrayUtil

	active_processes: []
	dead_processes: []
	pending_processes: []
	
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
		# console.log "::::::::::::::::::::::::::::::::: ON CHANGE"
		# console.log route

		@_filter_pending_processes route
		@_filter_dead_processes()
		
		# console.log "================= ACTIVES"
		# console.log route for route in @active_processes
		# console.log "<<<"

		# console.log "================= PENDINGS"
		# console.log route for route in @pending_processes
		# console.log "<<<"

		# console.log "================= DEAD"
		# console.log route for route in @dead_processes
		# console.log "<<<"

		@_destroy_dead_processes()


	# 2
	_filter_pending_processes:( route )->
		# console.log "Processes._filter_pending_processes for:"
		# console.log route

		@pending_processes = [ route ]
		while true && route && route.target_route
			search = raw: route: route.target_route
			# console.log "SEARCHING.... raw.route -> " + route.target_route
			route = ArrayUtil.find @router.routes, search
			route = route.item if route?

			# console.log "FOUND....?"
			# console.log route

			if route?
				# console.log "NEW DEPENDENCE"
				@pending_processes.push route

				if route.target_route is null
					# console.log "PARA TUDO!"
					break
			# else
				# console.log "DEPENDENCE NOT FOUND for search!"
				# console.log search

	# 3
	_filter_dead_processes:()->
		# console.log "Processes._filter_dead_processes"
		
		@dead_processes = []
		for route in @active_processes
			# console.log "$$$$$$$$$$$$ ACTIVE IS DEAD?"
			# console.log route

			search = {raw: {route: route.raw.route}}
			# console.log "@@@@ Search for #{route.raw.route} in pending_processes"
			found = ArrayUtil.find( @pending_processes, search )
			# console.log found
			if found is null
				# console.log "IS DEAD!"
				@dead_processes.push route
			# else
				# console.log "NOT DEAD!"
				# console.log route
				# console.log "<<<"

	# 4
	_destroy_dead_processes:()=>
		# console.log "Processes._destroy_dead_processes"
		
		if @dead_processes.length
			route = @dead_processes.pop()

			# console.log "DESTROY=============================================" + @active_processes.length
			# console.log active for active in @active_processes

			search = {raw: {route: route.raw.route}}
			ArrayUtil.delete @active_processes, search

			# console.log "DESTROYED=============================================" + @active_processes.length
			# console.log active for active in @active_processes

			console.log "Pr. DESTROY...."
			console.log route
			# route.api.controller._destroy @_destroy_dead_processes
			route.destroy @_destroy_dead_processes
		else
			console.log "All processes have benn, huh, destroyed."
			@_run_pending_processes()

	# 5
	_run_pending_processes:()=>
		# console.log "++++++++++++++++++++++++++++++++++++++"

		if @pending_processes.length
			route = @pending_processes.pop()
			# console.log "Processes._run_pending_processes for:"
			# console.log route
			search = {raw: route: route.raw.route}
			if ArrayUtil.find( @active_processes, search ) is null
				# console.log "RENDER IT!"
				@active_processes.push route
				# console.log "# RUNNING -> " + @_run_pending_processes
				route.run @_run_pending_processes
				# route.api.controller._run route, @_run_pending_processes
			else
				# console.log "ALREADY RENDERED!"
				@_run_pending_processes()
		else
			console.log "All processes have benn, huh, processed."