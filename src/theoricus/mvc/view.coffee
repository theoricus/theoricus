class View
	factory = null

	_boot:( @the )->
		factory = @the.factory
		@

	_render:( @route, auto_tmpl_name, @data = {} )->
		@el = $ @route.target_el

		if @render
			@render data
		else
			@render_template auto_tmpl_name, data

	render_template:( template, data )->
		template = factory.template @route.controller, template
		template.dom data
		dom = __ck.buffer.join ''
		__ck.buffer = []
		@el.append dom
		@in()

	in:( data )->
		@el.css "opacity", 0
		@el.animate {opacity: 1}, 1000, =>
			@after_render?()

	out:( data )->
		@el.animate {opacity: 0}, 1000, =>
			@after_destroy?()