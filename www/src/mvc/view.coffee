class theoricus.mvc.View
	Factory = null

	_boot:( @the )->
		Factory = @the.factory
		@

	render:( @data = {} )->
		# match = @classpath.match( /^app.views.([^\.]+).(.*)$/m )
		# aname = match[1]
		# cname = (match[2].replace "View", "").toLowerCase()

		api = @process.route.api
		cname = api.controller_name
		aname = api.action_name

		@el = $ @process.route.el

		template = Factory.template "#{cname}/#{aname}"
		dom = template data

		@el.append dom
		@in @after_in

		@set_triggers?()
		@

	in:( after_in )->
		animate = @the.config.enable_auto_transitions
		animate &= !@the.config.disable_transitions

		unless animate
			after_in?()
		else
			@el.css "opacity", 0
			@el.animate {opacity: 1}, 600, => after_in?()

	out:( after_out )->
		animate = @the.config.enable_auto_transitions
		animate &= !@the.config.disable_transitions

		unless animate
			after_out?()
		else
			@el.animate {opacity: 0}, 300, after_out

	navigate:( url )->
		@the.processes.router.navigate url