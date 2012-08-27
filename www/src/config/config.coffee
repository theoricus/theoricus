class theoricus.config.Config

	animate_at_startup: false
	enable_auto_transitions: true

	app_name: null
	no_push_state: null
	disable_transitions: null

	constructor:( @the )->
		@app_name = "app"

		@animate_at_startup = app.config.animate_at_startup ? false
		@enable_auto_transitions = app.config.enable_auto_transitions ? true

		@no_push_state = (typeof history.pushState isnt 'function')
		@no_push_state ||= /(\?|\&)(crawler)/.test window.location

		@disable_transitions = @no_push_state