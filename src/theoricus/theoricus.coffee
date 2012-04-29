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

		if /(\?|\&)(no\-transition)/.test window.location
			@boot.auto_transition = false

		@factory = new theoricus.core.Factory @
		@processes = new theoricus.core.Processes @