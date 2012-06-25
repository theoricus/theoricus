toast 'cli/src'
	alias: 'theoricus'
	expose: 'exports'
	exclude: ['generators/templates']
	release: 'lib/theoricus.cli.js'
	debug: 'lib/theoricus.cli.debug.js'

toast 'www/src'
	alias: 'theoricus'
	expose: 'window'
	vendors: [
		"www/vendors/history.adapter.native.js",
		"www/vendors/history.js",
		"www/vendors/jade.runtime.js",
		"www/vendors/jquery.js"
	]
	release: 'lib/theoricus.js'
	debug: 'lib/theoricus.debug.js'