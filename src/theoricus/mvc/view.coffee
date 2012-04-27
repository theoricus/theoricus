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
		template.dom data
		dom = __ck.buffer.join ''
		__ck.buffer = []
		@el.append dom
		@in()

	in:( data )->
		@el.css "opacity", 0
		@el.animate {opacity: 1}, 1000, =>
			@after_render?()

	out:( after_destroy )->
		@el.animate {opacity: 0}, 600, after_destroy

	navigate:( url )->
		@the.processes.router.navigate url