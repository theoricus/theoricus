#<< theoricus/commands/server
#<< theoricus/crawler/crawler

class Index

	fs = require "fs"
	path = require "path"
	FsUtil = (require "coffee-toaster").toaster.utils.FsUtil

	pages: {}

	constructor:( @the, @options )->
		@server = new theoricus.commands.Server @the, @options
		@get_page "http://localhost:11235/"


	get_page:( url )->

		new theoricus.crawler.Crawler url, ( src )=>
			@get_links url, src
			@save_page url, src
			@pages[url] = true
			for url, crawled of @pages
				return (@get_page url) unless crawled

			console.log "All pages indexed successfully.".bold.green
			process.exit()


	get_links:( url, src )->

		domain = url.match /(http:\/\/[\w]+:?[0-9]*)/g
		reg = /a\shref=(\"|\')(\/)?([^\'\"]+)/g

		while (matched = (reg.exec src))?
			url = "#{domain}/#{matched[3]}"
			@pages[url] = false unless @pages[url] is true


	save_page:( url, src )->
		folder = (/(http:\/\/)([\w]+)(:)?([0-9]+)?\/(.*)/g.exec url)[5]
		folder = path.normalize "#{@the.pwd}/public/static/#{folder}"
		FsUtil.mkdir_p folder unless path.existsSync( folder )

		fs.writeFileSync (file = path.normalize "#{folder}/index.html"), src
		console.log "Indexed ".bold.green + file