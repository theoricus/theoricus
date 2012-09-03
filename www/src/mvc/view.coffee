class theoricus.mvc.View
	Factory = null

	_boot:( @the )->
		Factory = @the.factory
		@

	render:( @data = {} )->
		api = @process.route.api
		cname = api.controller_name
		aname = api.action_name

		@el = $ @process.route.el

		template = Factory.template "#{cname}/#{aname}"
		@el.append (template @data)
		@set_triggers?()
		@in()
		@

	in:()->
		animate = @the.config.enable_auto_transitions
		animate &= !@the.config.disable_transitions

		unless animate
			@after_in()
		else
			@el.css "opacity", 0
			@el.animate {opacity: 1}, 600, => @after_in()

	out:( after_out )->
		animate = @the.config.enable_auto_transitions
		animate &= !@the.config.disable_transitions

		unless animate
			after_out()
		else
			@el.animate {opacity: 0}, 300, after_out

	navigate:( url )->
		@the.processes.router.navigate url