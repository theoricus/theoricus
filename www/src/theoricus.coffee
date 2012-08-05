#<< theoricus/*

class theoricus.Theoricus
	app: null
	root: null

	factory: null
	config: null
	processes: null

	crawler: (window.crawler = is_rendered: false)

	constructor:()->

		@config = new theoricus.config.Config @
		@factory = new theoricus.core.Factory @
		@processes = new theoricus.core.Processes @

new theoricus.Theoricus