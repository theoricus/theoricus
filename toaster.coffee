toast 'cli'
	expose: 'exports'
	exclude: [
		'theoricus/generators/templates'
		'theoricus/crawler/phantom.coffee'
	]
	release: 'lib/theoricus.cli.js'
	debug: 'lib/theoricus.cli.debug.js'

toast 'src'
	alias: 'theoricus'
	expose: 'window'
	release: 'lib/theoricus.js'
	debug: 'lib/theoricus.debug.js'