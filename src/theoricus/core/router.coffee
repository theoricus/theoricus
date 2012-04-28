#<< theoricus/utils/string_util

###
	Router inspired by:
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
			# console.log "URLLLLL >>>>  " + url
			for route in @routes
				if route.matcher.test url
					route.set_location url
					@on_change?( route )
					return

		@trigger = true

	navigate:( url, trigger = true, replace = false )->
		@trigger = trigger
		# console.log "History[#{if replace then "replaceState" else "pushState"}] null, #{url}, #{url}"
		History[if replace then "replaceState" else "pushState"] null, url, url

	run:( url, trigger = true )->
		# console.log "Router.run( '#{url}' )"
		@trigger = trigger
		@route {title:url}

	go:( index )->
		History.go index

	back:()->
		History.back()

	forward:()->
		History.forward()



class Route
	Factory = null
	StringUtil = theoricus.utils.StringUtil

	@named_param_reg: /:\w+/g
	@splat_param_reg: /\*\w+/g

	api: null
	location: null

	constructor:( route, to, at, router )->
		Factory = router.the.factory

		# raw representation of the route
		@raw = route:route, to:to, at:at
		
		# route regexp matcher
		@matcher = route.replace Route.named_param_reg, '([^\/]+)'
		@matcher = @matcher.replace Route.splat_param_reg, '(.*?)'
		@matcher = new RegExp "^#{@matcher}$"

		@api = {}
		@api.controller_name = to.split( "/" )[0]
		@api.controller = Factory.controller @api.controller_name
		@api.action = to.split( "/" )[1]

		# evalueates target_route & target_el
		if /\#/g.test at
			@target_route = at.split( "#" )[0]
			@target_el = "#" + at.split( "#" )[1]
		else
			@target_route = null
			@target_el = at
	
	run:( after_run )->
		@api.controller._run @, after_run

	destroy:( after_destroy )->
		@api.controller._destroy @, after_destroy

	set_location:( location )->
		@location = location
		@api.params = @matcher.exec( location ).slice 1