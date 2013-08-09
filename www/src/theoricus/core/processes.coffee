###*
  Core module
  @module core
###

Router = require 'theoricus/core/router'
Process = require 'theoricus/core/process'
_ = require 'lodash'

Factory = null

module.exports = class Processes

  # utils

  # variables
  ###*
  Block the url state to be changed. Useful if there is a current {{#crossLink "Process"}}__Process__{{/crossLink}} being executed.

  @property {Boolean} locked
  ###
  locked: false
  disable_transitions: null

  ###*
    Stores the current processes that are active.

    @property active_processes {Array}
  ###
  active_processes: []

  ###*
    Stores the current processes that doesn't need to be active.

    @property dead_processes {Array}
  ###
  dead_processes: []

  ###*
    Stores the new Process dependencies.

    @property pending_processes {Array}
  ###
  pending_processes: []

  ###*
  Responsible for handling the url change. 

  When the URL changes, it initializes the Process responsible for the current Route (which is responsible for the current URL).
  
  Stores the new Process dependency processes at `@pending_processes`
  
  Destroy the current processes that are active, but are not dependency of the new Process.
  
  Runs the processes that are not active yet. 

  __Execution order__

  1. `_on_router_change` : 

      The URL changed, it will create a new Process to handle the current Route.

  2. `_filter_pending_processes`

      Will search for all the new Process dependencies recursively, and store them at `pending_processes`

  3. `_filter_dead_processes`

      Will search for all the processes that doesn't need to be active.

  4. `_destroy_dead_processes` - one by one, waiting or not for callback (timing can be sync/async)

      Will destroy the processes that doesn't need to be active.

  6. `_run_pending_process` - one by one, waiting or not for callback (timing can be sync/async)

      Will run the process that are required, but not active yet.

  @class Processes
  @constructor
  @param @the {Theoricus} Shortcut for app's instance.
  @param @Routes {Object} App routes defined in the `routes.coffee`
  ###
  constructor:( @the, @Routes )->
    Factory = @the.factory

    if @the.config.animate_at_startup is false
      @disable_transitions = @the.config.disable_transitions
      @the.config.disable_transitions = true

    $(document).ready =>
      @router = new Router @the, @Routes, @_on_router_change

  ###*
  Executed when the url changes, it creates a {{#crossLink "Process"}}__Process__{{/crossLink}} to manipulate the route, removes the current process, and run the new process alongside its dependencies.
  
  @method _on_router_change
  @param route {Route} Route containing the controller and url state information.
  @param url {String} Current url state.
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

  ###*
    Searchs and stores the {{#crossLink "Process"}}__Process__{{/crossLink}} dependencies recursively.

    @method _filter_pending_processes
    @param process {Process} Process to search the dependencies.
    @param after_filter {Function} Callback to be called when all the dependencies are stored.
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

  ###*
  Finds the dependency of the given {{#crossLink "Process"}}__Process__{{/crossLink}}

  @method _find_dependency
  @param process {Process} Process to find the dependency.
  @param after_find {Function} Callback to be called after the dependency has been found.
  ###
  _find_dependency:( process, after_find )->
    dependency = process.dependency

    # 1 - tries to find dependency within the ACTIVE PROCESSES
    dep = _.find @active_processes, (item)->
      return item.url is dependency
    return after_find dep if dep?

    # 2 - tries to find dependency within the ROUTES (using strict route name)
    dep = _.find @router.routes, (item)->
      return item.test dependency

    if dep?

      # assemble route's `at` dependency based on parent url params
      params = dep.extract_params process.dependency
      at = dep.rewrite_url_with_parms dep.at, params

      return new Process @the, @, dep, at, dependency, process, (process)=>
        after_find process

    after_find null


  ###*
  Check which of the processes needs to stay active in order to render current process.
  The ones that doesn't, are pushed to `@dead_processes`.

  @method _filter_dead_processes
  ###
  _filter_dead_processes:()->
    @dead_processes = []

    # loops through all active process
    for active in @active_processes

      # and checks if it's present in the pending_processes as well
      process = _.find @pending_processes, (item)->
        return item.url is active.url

      if process?
        url = process.url
        if url? && url != active.url
          @dead_processes.push active
      else
        @dead_processes.push active

  ###*
  Destroy the dead processes (doesn't need to be active) one by one, then run the pending process.

  @method _destroy_dead_processes
  ###
  _destroy_dead_processes:()=>
    if @dead_processes.length
      process = @dead_processes.pop()

      @active_processes = _.reject @active_processes, (p)->
        p.route.match is process.route.match

      process.destroy @_destroy_dead_processes

    else
      @_run_pending_processes()

  ###*
  Run the processes that are not active yet.

  @method _run_pending_processes
  ###
  _run_pending_processes:()=>
    if @pending_processes.length

      process = @pending_processes.pop()
      found = _.find @active_processes, (found_process)->
        return found_process.route.match is process.route.match

      unless found?
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

      # calls the activate for the last active process only
      (_.last @active_processes).on_activate?()