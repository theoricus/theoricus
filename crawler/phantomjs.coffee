fs = require 'fs'
page = require('webpage').create()
url = phantom.args[ 0 ]

# page.onConsoleMessage=( msg )-> console.log msg

page.open url, ->
	setInterval ->
		return unless (page.evaluate ->
			return window && window.crawler && window.crawler.is_rendered
		)

		# page.render "phantom.png"
		# fs.write "phantom.html", page.content
		console.log page.content
		phantom.exit()
	, 30