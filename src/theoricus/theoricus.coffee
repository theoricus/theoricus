#<< theoricus/core/*
#<< theoricus/config/*
#<< theoricus/core/*

class Theoricus
	app: null
	root: null
	
	factory: null
	config: null
	processes: null
	
	constructor:( @boot )->
		# console.log "Theoricus is born!"
		@boot.name = @boot.name ? "app"

		@config = new theoricus.config.Config @
		@factory = new theoricus.core.Factory @
		@processes = new theoricus.core.Processes @