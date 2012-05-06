#<< theoricus/core/*
#<< theoricus/config/*
#<< theoricus/core/*

class Theoricus
	app: null
	root: null

	factory: null
	config: null
	processes: null

	crawler: (window.crawler = is_rendered: false)

	constructor:( @boot )->
		@boot.name = "app"
		@boot.no_push_state = (typeof history.pushState is not 'function')
		@boot.disable_transitions =	@boot.no_push_state or
									 /(\?|\&)(crawler)/.test window.location

		@factory = new theoricus.core.Factory @
		@processes = new theoricus.core.Processes @