#<< theoricus/utils/string_util
#<< theoricus/core/route

###
	Router Logic inspired by RouterJS:
	https://github.com/haithembelhaj/RouterJs
###

class Router
	Factory = null

	routes: []
	listeners: []

	trigger: true

	constructor:( @the, @on_change )->
		Factory = @the.factory
		@map route, opts.to, opts.at for route, opts of @the.boot.routes
		History.Adapter.bind window, 'statechange', => @route History.getState()
		setTimeout (=>
			url = window.location.pathname
			url = @the.boot.boot if url == "/"
			@run url
		), 1

	map:( route, to, at )->
		@routes.push new theoricus.core.Route route, to, at, @

	route:( state )->
		if @trigger
			url = state.title or state.hash
			url = @the.boot.boot if url == "/"
			for route in @routes
				if route.matcher.test url
					route.set_location url
					@on_change?( route )
					return

		@trigger = true

	navigate:( url, trigger = true, replace = false )->
		@trigger = trigger
		action = if replace then "replaceState" else "pushState"
		History[action] null, url, url

	run:( url, trigger = true )->
		@trigger = trigger
		@route {title:url}

	go:( index )->
		History.go index

	back:()->
		History.back()

	forward:()->
		History.forward()