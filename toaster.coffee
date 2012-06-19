toast 'cli/src'
	alias: 'theoricus'
	expose: 'exports'
	exclude: ['generators/templates']
	release: 'lib/theoricus.cli.js'
	debug: 'lib/theoricus.cli.debug.js'

toast 'www/src'
	alias: 'theoricus'
	expose: 'window'
	release: 'lib/theoricus.js'
	debug: 'lib/theoricus.debug.js'