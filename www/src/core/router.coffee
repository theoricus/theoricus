#<< theoricus/utils/string_util
#<< theoricus/core/route

## Router & Route logic inspired by RouterJS:
## https://github.com/haithembelhaj/RouterJs

class theoricus.core.Router
	Factory = null

	routes: []
	listeners: []

	trigger: true

	constructor:( @the, @on_change )->
		Factory = @the.factory

		for route, opts of app.routes
			@map route, opts.to, opts.at, opts.el, @

		History.Adapter.bind window, 'statechange', =>
			@route History.getState()

		setTimeout =>
			url = window.location.pathname
			url = app.root if url == "/"
			@run url
		, 1

	map:( route, to, at, el )->
		@routes.push new theoricus.core.Route route, to, at, el, @

	route:( state )->

		if @trigger

			# url from HistoryJS
			url = state.hash || state.title

			# removes the prepended '.' from HistoryJS
			url = url.slice 1 if (url.slice 0, 1) is '.'

			# adding back the first slash '/' in cases it's removed by HistoryJS
			url = "/#{url}" if (url.slice 0, 1) isnt '/'

			# fallback to root url in case user enter the '/'
			url = app.root if url == "/"

			for route in @routes
				if route.matcher.test url
					@on_change?( route.clone url )
					return
		
		@trigger = true

	navigate:( url, trigger = true, replace = false )->
		# console.log "NAVIGATE ->>> '#{url}'"
		
		@trigger = trigger
		action = if replace then "replaceState" else "pushState"
		History[action] null, null, url

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