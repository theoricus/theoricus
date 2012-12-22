#<< theoricus/utils/string_util

###
Responsible for "running" a [theoricus.core.Route] Route

 @author {https://github.com/arboleya arboleya}
###
class theoricus.core.Process

	# utils
	{StringUtil} = theoricus.utils

	# @property [theoricus.mvc.Controller] controller
	controller: null

	# @property [theoricus.core.Route] route
	route: null

	###
	Instantiate controller responsible for the route
	
	@param [theoricus.Theoricus] @the   Shortcut for current app's instace
	@route [theoricus.core.Route] @route Route responsible for the process
	###
	constructor:( @the, @route )->
		# instantiates controller
		@controller = @the.factory.controller @route.api.controller_name

	###
	Executes controller's action, in case it isn't declared executes an 
	standard one.
	
	@return [theoricus.mvc.View] view
	###
	run:( after_run )->
		# if action is not defined, defines the default action behaviour for it
		unless @controller[ action = @route.api.action_name ]
			@controller[ action ] = @controller._build_action @

		# inject the current process into controller
		@controller.process = @

		# creates callback to reset things
		@after_run = =>
			@controller.process = null
			after_run()

		# executes the action and catches the resulting view
		@view = @controller[ action ].apply @controller, @route.api.params

	###
	Executes view's transition "out" method, wait for its end
	empty the dom element and then call a callback
	
	@return [theoricus.mvc.View] view
	###
	destroy:( @after_destroy )->
		# call the OUT transition with the given callback
		if not @view?
			console.warn "View isn't defined, please check if you controller method is returning the rendered view"
			@after_destroy()
			return

		@view.out =>
			@view.destroy()
			@after_destroy?()
