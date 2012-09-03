#<< theoricus/utils/string_util

class theoricus.core.Process

	# utils
	{StringUtil} = theoricus.utils

	# variables
	controller: null

	constructor:( @the, @route )->
		# instantiates controller
		@controller = @the.factory.controller @route.api.controller_name

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

	destroy:( @after_destroy )->
		# call the OUT transition with the given callback
		@view.out =>
			@view.el.empty()
			@after_destroy()