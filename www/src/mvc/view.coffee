class theoricus.mvc.View
	Factory = null

	# $ reference to dom element
	el: null

	# @property [String] class path
	classpath : null
	# @property [String] class name
	classname : null
	# @property [String] namespace
	namespace : null
	# @property [theoricus.core.Process] process
	process   : null

	###
	@param [theoricus.Theoricus] @the   Shortcut for app's instance
	###
	_boot:( @the )->
		Factory = @the.factory
		@

	###
	@param [Object] @data   Data to be passed to the template
	@param [Object] @el 	Element where the view will be "attached/appended"
	###
	render:( @data = {}, el = @process.route.el, template = null )=>
		@before_render?(@data)

		if not @el
			api = @process.route.api

			@el = $ el

			if template == null

				tmpl_folder = @namespace.singularize()
				tmpl_name   = @classname.underscore()

				template = Factory.template "#{tmpl_folder}/#{tmpl_name}"

			dom = template(@data) if template?

			@el.append dom || $ '<div>'

			@in()

		@set_triggers?()

		@after_render?(@data)

		###
		In case you define an "on_resize" handler it will be automatically 
		binded and triggered
		###
		if @on_resize?
			$( window ).unbind 'resize', @on_resize
			$( window ).bind   'resize', @on_resize
			@on_resize()

	require: ( view, container, data = @data, template ) ->
		view = @view view

		if container
			view.render data, @el.find container, template

		view

	###
	In case you defined @events in your view they will be automatically binded
	###
	set_triggers: () =>
		return if not @events?

		for sel, funk of @events
			[all, sel, ev] = sel.match /(.*)[\s|\t]+([\S]+)$/m

			( @el.find sel ).unbind ev, null, @[funk]
			( @el.find sel ).bind   ev, null, @[funk]

	###
	Called before completely erasing the view
	###
	destroy: () ->
		@before_destroy?()

		@el.empty()

	###
	Triggers view "animation in", "@after_in" must be called in the end
	###
	in:()->
		@before_in?()

		animate  = @the.config.enable_auto_transitions
		animate &= !@the.config.disable_transitions

		unless animate
			@after_in?()
		else
			@el.css "opacity", 0
			@el.animate {opacity: 1}, 600, => @after_in?()

	###
	Triggers view "animation out", "after_out" must be called in the end

	@param [Function] after_out	Callback function to be triggered in the end
	###
	out:( after_out )->
		@before_out?()

		animate  = @the.config.enable_auto_transitions
		animate &= !@the.config.disable_transitions

		unless animate
			after_out()
		else
			@el.animate {opacity: 0}, 300, after_out



	# ~> Shortcuts

	###
	Shortcut for application navigate

	@param [String] url	URL to navigate
	###
	navigate:( url )->
		@the.processes.router.navigate url

	###
	Shortcut for Factory.view method

	@param [String] path	Path to view file
	###
	view:( path )->
		Factory.view path, @process

	###
	Shortcut for Factory.template method

	@param [String] url	Path to template file
	###
	template:( path )->
		Factory.template path
