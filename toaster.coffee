# => SRC FOLDER
toast 'src'
	vendors:[
		"vendors/history.js"
		"vendors/history.adapter.native.js"
		"vendors/jquery.js"
		"vendors/coffeekup.js"
	]

	# => OPTIONS (optional, default values listed)
	# bare: false
	# packaging: true
	# expose: ''
	# minify: true
	exclude: [
		# "app/static"
		# "app/views/templates"
	]

	# => HTTPFOLDER (optional), RELEASE / DEBUG (required)
	httpfolder: ''
	release: 'public/app.js'
	debug: 'public/app-debug.js'