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
		unless (c=@controller)[ action = @route.api.action_name ]
			c[ action ] = c._build_action @

		# executes the action and catches the resulting view
		@controller.process = @
		@view = c[ action ].apply c, @route.api.params
		
		# call the IN transition with the given callback
		@view.in =>
			@controller.process = null
			after_run()

	destroy:( after_destroy )->
		# call the OUT transition with the given callback
		@view.out =>
			@view.el.empty()
			after_destroy()