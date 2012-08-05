#<< theoricus/utils/array_util
#<< theoricus/core/router

class theoricus.core.Processes
	Factory = null
	ArrayUtil = theoricus.utils.ArrayUtil

	locked: false
	disable_transitions: null

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

		if @the.config.animate_at_startup is false
			@disable_transitions = @the.config.disable_transitions
			@the.config.disable_transitions = true


		$(document).ready =>
			@router = new theoricus.core.Router @the, @_on_router_change

	# 1
	_on_router_change:( route )=>

		return @router.navigate @last_route.location, false, true if @locked

		@last_route = route
		@locked = true
		@the.crawler.is_rendered = false

		@_filter_pending_processes route
		@_filter_dead_processes()
		@_destroy_dead_processes()

	# 2
	_filter_pending_processes:( route )->
		@pending_processes = [ route ]
		while true && route && route.target_route
			search = raw: route: route.target_route
			route = ArrayUtil.find @router.routes, search
			route = route.item.clone() if route?
			if route?
				@pending_processes.push route
				break if route.target_route is null

	# 3
	_filter_dead_processes:()->
		@dead_processes = []
		for active in @active_processes
			search = raw: route: active.raw.route
			found = ArrayUtil.find @pending_processes, search
			
			if found?
				location = found.item.location
				if location? && location != active.location
					found = null

			if found is null
				@dead_processes.push active

	# 4
	_destroy_dead_processes:()=>
		if @dead_processes.length
			route = @dead_processes.pop()
			search = raw: route: route.raw.route
			ArrayUtil.delete @active_processes, search
			route.destroy @_destroy_dead_processes
		else
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
			@locked = false
			@the.crawler.is_rendered = true

			if @disable_transitions?
				@the.config.disable_transitions = @disable_transitions
				@disable_transitions = null