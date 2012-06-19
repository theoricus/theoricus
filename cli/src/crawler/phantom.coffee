fs = require 'fs'
page = require('webpage').create()
url = phantom.args[ 0 ]

page.open url, ->
	setInterval ->
		return unless (page.evaluate ->
			return window && window.crawler && window.crawler.is_rendered
		)
		console.log page.content
		phantom.exit()
	, 30