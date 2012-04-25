class View
	factory = null

	boot:( @the )->
		factory = @the.factory
		@

	_render:( @route, @data = {} )->
		console.log "View.render()"
		console.log @route
		if @render
			@render data
		else
			@render_template @route.controller, data

	render_template:( template, data )->
		# console.log "View.write()"
		template = factory.template template
		template.dom data
		dom = __ck.buffer.join ''

		$( @route.at ).append dom
		@in()

	in:( data )->
		$( @route.at ).css "opacity", 0
		$( @route.at ).animate {opacity: 1}, 1000

	out:( data )->
		$( @route.at ).animate {opacity: 0}, 1000