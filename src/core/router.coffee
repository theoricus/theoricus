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

		for route, opts of app.routes
			@map route, opts.to, opts.at, opts.el, @

		History.Adapter.bind window, 'statechange', => @route History.getState()
		setTimeout (=>
			url = window.location.pathname
			url = app.root if url == "/"
			@run url
		), 1

	map:( route, to, at, el )->
		@routes.push new theoricus.core.Route route, to, at, el, @

	route:( state )->
		if @trigger
			url = state.title or state.hash
			url = app.root if url == "/"
			for route in @routes
				if route.matcher.test url
					route.set_location url
					@on_change?( route )
					return

		@trigger = true

	navigate:( url, trigger = true, replace = false )->
		if @the.config.no_push_state
			window.location = url
			return
		else
			@trigger = trigger
			action = if replace then "replaceState" else "pushState"
			History[action] null, url, url

	run:( url, trigger = true )->
		# console.log "Router.run #{url}, #{trigger}"
		@trigger = trigger
		@route {title:url}

	go:( index )->
		History.go index

	back:()->
		History.back()

	forward:()->
		History.forward()