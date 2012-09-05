toast 'cli/src'
	alias: 'theoricus'
	expose: 'exports'
	exclude: ['generators/templates']
	minify: false
	release: 'lib/theoricus.cli.js'
	debug: 'lib/theoricus.cli.debug.js'

toast 'www/src'
	alias: 'theoricus'
	expose: 'window'
	vendors: [
		"www/vendors/history.js/scripts/bundled/html4+html5/native.history.js"
		"www/vendors/jade/runtime.js"
		"www/vendors/inflection/lib/inflection.js"
		"www/vendors/jquery.js"
		"www/vendors/JSON-js/json2.js"
	]
	minify: false
	release: 'lib/theoricus.js'
	debug: 'lib/theoricus.debug.js'