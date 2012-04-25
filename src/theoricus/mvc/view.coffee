class View
	factory = null

	boot:( @the )->
		factory = @the.factory
		@

	_render:( @route, @data = {} )->
		@el = $ @route.target_el

		if @render
			@render data
		else
			@render_template @route.controller, data

	render_template:( template, data )->
		template = factory.template template
		template.dom data
		dom = __ck.buffer.join ''

		@el.append dom
		@in()

	in:( data )->
		@el.css "opacity", 0
		@el.animate {opacity: 1}, 1000

	out:( data )->
		@el.animate {opacity: 0}, 1000