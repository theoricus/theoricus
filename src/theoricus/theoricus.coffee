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
		@boot.name = "app"
		@factory = new theoricus.core.Factory @
		@processes = new theoricus.core.Processes @