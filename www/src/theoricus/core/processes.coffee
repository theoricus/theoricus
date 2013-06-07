ArrayUtil = require 'theoricus/utils/array_util'
Router = require 'theoricus/core/router'
Process = require 'theoricus/core/process'
_ = require 'lodash'

Factory = null

module.exports = class Processes

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
  constructor:( @the, @Routes )->
    Factory = @the.factory

    if @the.config.animate_at_startup is false
      @disable_transitions = @the.config.disable_transitions
      @the.config.disable_transitions = true

    $(document).ready =>
      @router = new Router @the, @Routes, @_on_router_change

  ###
  1st

  Triggered on router chance

  @param [theoricus.core.Router] route
  ###
  _on_router_change:( route, url )=>
    if @locked
      return @router.navigate @last_process.url, 0, 1 

    @locked = true
    @the.crawler.is_rendered = false

    new Process @the, @, route, route.at, url, null, ( process, controller )=>

      @last_process = process

      @pending_processes = []
      @_filter_pending_processes process, =>
        do @_filter_dead_processes
        do @_destroy_dead_processes

  ###
  2nd

  Check if target scope ( for rendering ) exists
  If yes adds it to pending_process list
  If no  throws an error

  @param [theoricus.core.Process] process
  ###
  _filter_pending_processes:( process, after_filter )->

    @pending_processes.push process

    # if process has a dependency
    if process.dependency?

      # search for it
      @_find_dependency process, (dependency) =>

        # if dependency is found
        if dependency?

          # searchs for its dependencies recursively
          @_filter_pending_processes dependency, after_filter

        # otherwise rises an error of dependency not found
        else
          a = process.dependecy
          b = process.route.at

          console.error "Dependency not found for #{a} and/or #{b}"
          console.log process

    # otherwise fires callback
    else
      do after_filter

  # try to finds the dependency in many ways
  _find_dependency:( process, after_find )->

    # 1 - tries to find dependency within the ACTIVE PROCESSES
    dep = _.filter @active_processes, (item)->
      return item.url is process.dependency
    return after_find dep[0] if dep.length

    # 2 - tries to find dependency within the ROUTES (using strict route name)
    dep = _.filter @router.routes, (item)->
      return item.test process.dependency

    if dep.length
      # rewriting route dependency based on parent url params
      params = dep[0].extract_params process.dependency
      at = dep[0].rewrite_url_with_parms dep[0].at, params

      return new Process @the, @, dep[0], at, process.dependency, process, (process)=>
        after_find process

    after_find null


  ###
  3th

  Check which of the routes needs to stay active in order to render
  current process.
  The ones that doesn't, are pushed to dead_processes
  ###
  _filter_dead_processes:()->
    @dead_processes = []

    # loops through all active process
    for active in @active_processes

      # and checks if it's present in the pending processes as well
      found = ArrayUtil.find @pending_processes, url: active.url

      if (process = found?.item)?
        url = process.url
        if url? && url != active.url
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