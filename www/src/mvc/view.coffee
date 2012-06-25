class View
	Factory = null

	_boot:( @the )->
		Factory = @the.factory
		@

	_render:( @route, auto_tmpl_name, @data = {} )->
		@el = $ @route.target_el

		if @render
			@render data
		else
			@render_template auto_tmpl_name, data

		@set_triggers?()

	render_template:( template, data )->
		template = Factory.template @route.api.controller_name, template
		dom = template data
		@el.append dom
		@in @after_in

	in:( after_in )->
		animate = !@the.config.enable_auto_transitions
		animate ||= @the.config.disable_transitions
		animate ||= @the.config.disable_auto_transitions

		if animate
			after_in?()
		else
			@el.css "opacity", 0
			@el.animate {opacity: 1}, 600, => after_in?()

	out:( after_out )->
		animate = !@the.config.enable_auto_transitions
		animate ||= @the.config.disable_transitions
		animate ||= @the.config.disable_auto_transitions

		if animate
			after_out?()
		else
			@el.animate {opacity: 0}, 300, after_out

	navigate:( url )->
		@the.processes.router.navigate url