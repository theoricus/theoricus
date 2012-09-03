#<< theoricus/utils/array_util
#<< theoricus/core/router

class theoricus.core.Processes

	# utils
	Factory = null
	{ArrayUtil} = theoricus.utils

	# variables
	locked: false
	disable_transitions: null

	active_processes: []
	dead_processes: []
	pending_processes: []

	# EXEC ORDER
	# --------------------------------------------------------------------------
	#	1. _on_router_change
	#	2. _filter_pending_processes
	#	3. _filter_dead_processes
	#	4. _destroy_dead_processes - one by one, waiting or not foll callback
	#		4.1 Timing can be sync/async
	#	5. _run_pending_process - one by one, waiting or not foll callback
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
		return @router.navigate @last_process.route.location, 0, 1 if @locked

		process = new theoricus.core.Process @the, route
		@last_process = process
		@locked = true
		@the.crawler.is_rendered = false

		@_filter_pending_processes process
		@_filter_dead_processes()
		@_destroy_dead_processes()

	# 2
	_filter_pending_processes:( process )->
		@pending_processes = [ process ]
		while process && process.route.at
			if(route = ArrayUtil.find @router.routes, match: process.route.at)?
				process = new theoricus.core.Process @the, route.item.clone()
				@pending_processes.push process
				break if route.target_route is null
			else
				console.log "ERROR: Dependency not found at=#{process.route.at}"
				console.log process.route
				break

	# 3
	_filter_dead_processes:()->
		@dead_processes = []
		for active in @active_processes
			search = route: match: active.route.match
			if (found = ArrayUtil.find @pending_processes, search)?
				location = found.item.route.location
				if location? && location != active.route.location
					found = null
			else
				@dead_processes.push active

	# 4
	_destroy_dead_processes:()=>
		if @dead_processes.length
			process = @dead_processes.pop()
			process.destroy @_destroy_dead_processes
			search = route: match: process.route.match
			ArrayUtil.delete @active_processes, search
		else
			@_run_pending_processes()

	# 5
	_run_pending_processes:()=>
		if @pending_processes.length
			process = @pending_processes.pop()
			search = route: match: process.route.match
			unless ArrayUtil.find( @active_processes, search )?
				@active_processes.push process
				process.run @_run_pending_processes
			else
				@_run_pending_processes()
		else
			@locked = false
			@the.crawler.is_rendered = true

			if @disable_transitions?
				@the.config.disable_transitions = @disable_transitions
				@disable_transitions = null