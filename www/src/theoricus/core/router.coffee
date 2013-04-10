## Router & Route logic inspired by RouterJS:
## https://github.com/haithembelhaj/RouterJs

StringUril = require 'theoricus/utils/string_util'
Route = require 'theoricus/core/route'
Routes = require 'app/config/routes'

require 'history'

Factory = null

###
Proxyes browser's History API, routing request to and from the aplication
###
class Router

  routes: []
  listeners: []

  trigger: true

  ###
  @param [theoricus.Theoricus] @the   Shortcut for app's instance
  @param [Function] @on_change  state/url change handler
  ###
  constructor:( @the, @on_change )->
    Factory = @the.factory

    for route, opts of Routes.routes
      @map route, opts.to, opts.at, opts.el, @

    History.Adapter.bind window, 'statechange', =>
      @route History.getState()

    setTimeout =>
      url = window.location.pathname
      url = Routes.root if url == "/"
      @run url
    , 1

  ###
  Creates and store a route
  
  @param [String] route
  @param [String] to
  @param [String] at
  @param [String] el
  ###
  map:( route, to, at, el )->
    @routes.push new Route route, to, at, el, @

  route:( state )->

    if @trigger

      # url from HistoryJS
      url = state.hash || state.title

      # FIXME: quickfix for IE8 bug
      url = url.replace( '.', '' )

      #remove base path from incoming url
      ( url = url.replace @the.base_path, '' ) if @the.base_path?
      
      # removes the prepended '.' from HistoryJS
      url = url.slice 1 if (url.slice 0, 1) is '.'

      # adding back the first slash '/' in cases it's removed by HistoryJS
      url = "/#{url}" if (url.slice 0, 1) isnt '/'

      # fallback to root url in case user enter the '/'
      url = Routes.root if url == "/"

      for route in @routes
        if route.matcher.test url
          @on_change?( route.clone url )
          return
    
    @trigger = true

  navigate:( url, trigger = true, replace = false )->
    @trigger = trigger

    action   = if replace then "replaceState" else "pushState"
    History[action] null, null, url

  run:( url, trigger = true )=>
    ( url = url.replace @the.base_path, '' ) if @the.base_path?

    @trigger = trigger
    @route { title: url }

  go:( index )->
    History.go index

  back:()->
    History.back()

  forward:()->
    History.forward()