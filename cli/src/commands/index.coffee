#<< theoricus/commands/server
#<< theoricus/crawler/crawler

class theoricus.commands.Index

	fs = require "fs"
	exec = (require "child_process").exec
	path = require "path"
	FsUtil = (require "coffee-toaster").toaster.utils.FsUtil

	pages: {}

	constructor:( @the, @options )->

		exec "phantomjs -v", (error, stdout, stderr)=>
			if /phantomjs: command not found/.test stderr
				console.log "Error ".bold.red + "Install #{'phantomjs'.yellow}"+
							" before indexing pages."+
							"\n\thttp://phantomjs.org/"
			else
				@server = new theoricus.commands.Server @the, @options
				console.log "Start indexing...".bold.green
				@crawler = new theoricus.crawler.Crawler =>
					@get_page "http://localhost:11235/"


	get_page:( url )->

		@crawler.get_src url, (src)=>

			@get_links url, src
			@save_page url, src
			@pages[url] = true

			for url, crawled of @pages
				return (@get_page url) unless crawled

			from = "#{@the.pwd}/public"
			to = "#{@the.pwd}/public/static"
			
			# src = fs.readFileSync "#{from}/app.js", "utf-8"
			# fs.writeFileSync "#{to}/app.js", src
			fs.writeFileSync "#{to}/app.js", ""

			src = fs.readFileSync "#{from}/app.css", "utf-8"
			fs.writeFileSync "#{to}/app.css", src

			console.log "Pages indexed successfully.".bold.green

			@crawler.exit()
			@server.close_server()
			@static_server = new theoricus.commands.StaticServer @the, @options


	get_links:( url, src )->

		domain = url.match /(http:\/\/[\w]+:?[0-9]*)/g
		reg = /a\shref=(\"|\')(\/)?([^\'\"]+)/g

		while (matched = (reg.exec src))?
			url = "#{domain}/#{matched[3]}"
			@pages[url] = false unless @pages[url] is true


	save_page:( url, src )->

		route = (/(http:\/\/)([\w]+)(:)?([0-9]+)?\/(.*)/g.exec url)[5]
		folder = path.normalize "#{@the.pwd}/public/static/#{route}"
		FsUtil.mkdir_p folder unless fs.existsSync( folder )

		src = ((require 'pretty-data').pd.xml src) + "\n"
		fs.writeFileSync (file = path.normalize "#{folder}/index.html"), src
		route = (route || "/").bold.yellow
		console.log "\t#{route.bold.yellow} -> #{file}"