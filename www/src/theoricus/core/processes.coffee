ArrayUtil = require 'theoricus/utils/array_util'
Router = require 'theoricus/core/router'
Process = require 'theoricus/core/process'

Factory = null

class Processes

  # utils

  # variables
  locked: false
  disable_transitions: null

  active_processes: []
  dead_processes: []
  pending_processes: []

  # EXEC ORDER
  # --------------------------------------------------------------------------
  # 1. _on_router_change
  # 2. _filter_pending_processes
  # 3. _filter_dead_processes
  # 4. _destroy_dead_processes - one by one, waiting or not foll callback
  #   4.1 Timing can be sync/async
  # 5. _run_pending_process - one by one, waiting or not foll callback
  #   5.1 timing can be sync/async
  # --------------------------------------------------------------------------

  ###
  @param [theoricus.Theoricus] @the   Shortcut for app's instance
  ###
  constructor:( @the )->
    Factory = @the.factory

    if @the.config.animate_at_startup is false
      @disable_transitions = @the.config.disable_transitions
      @the.config.disable_transitions = true

    $(document).ready =>
      @router = new Router @the, @_on_router_change

  ###
  1st

  Triggered on router chance

  @param [theoricus.core.Router] route
  ###
  _on_router_change:( route )=>
    if @locked
      return @router.navigate @last_process.route.location, 0, 1 

    process = new Process @the, route
    @last_process = process
    @locked = true
    @the.crawler.is_rendered = false

    @_filter_pending_processes process
    @_filter_dead_processes()
    @_destroy_dead_processes()

  ###
  2nd

  Check if target scope ( for rendering ) exists
  If yes adds it to pending_process list
  If no  throws an error

  @param [theoricus.core.Process] process
  ###
  _filter_pending_processes:( process )->
    @pending_processes = [ process ]

    while process && process.route.at
      route = ArrayUtil.find( @router.routes, match: process.route.at )

      if route?
        process = new Process @the, route.item.clone()
        @pending_processes.push process
        break if route.target_route is null
      else
        console.log "ERROR: Dependency not found at=#{process.route.at}"
        console.log process.route
        break

  ###
  3th

  Check which of the routes needs to stay active in order to render
  current process.
  The ones that doesn't, are pushed to dead_processes
  ###
  _filter_dead_processes:()->
    @dead_processes = []

    for active in @active_processes

      search = route: match: active.route.match
      found  = ArrayUtil.find( @pending_processes, search )

      if found?
        location = found.item.route.location
        if location? && location != active.route.location
          @dead_processes.push active
      else
        @dead_processes.push active

  ###
  4th

  Destroy dead processes one by one ( passing the next destroy as callback )
  then run the pending proccess
  ###
  _destroy_dead_processes:()=>
    if @dead_processes.length
      process = @dead_processes.pop()
      process.destroy @_destroy_dead_processes
      search = route: match: process.route.match
      ArrayUtil.delete @active_processes, search
    else
      @_run_pending_processes()

  ###
  5th
  Execute run method of pending processes that are not active
  ###
  _run_pending_processes:()=>
    if @pending_processes.length
      process = @pending_processes.pop()
      search  = route: match: process.route.match
      found = ArrayUtil.find( @active_processes, search )?

      if not found
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