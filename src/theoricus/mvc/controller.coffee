class Controller
	factory = null

	boot:( @the )->
		factory = @the.factory
		console.log "Controller.boot()"
		@
	
	render:( view, data )->
		view = factory.view "main"
		view._render @route, data
	
	routing:( @route )->