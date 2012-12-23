class theoricus.commands.Server
	http = require "http"
	url  = require "url"
	fs   = require "fs"
	path = require "path"
	pn   = path.normalize

	exec = require( "child_process" ).exec

	constructor:( @the, options )->
		@port = options[1] or 11235
		@root = "#{@the.pwd}/public"

		# console.log  "Server is born()"
		@start_server()
		@compiler = new theoricus.commands.Compiler @the, true

	start_server:()->
		@server = http.createServer( @_handler ).listen @port
		console.log "#{'Server running at'.bold} http://localhost:#{@port}".grey

	close_server:()->
		@server.close()


	_handler:(request, response)=>

		headers = request.headers
		agent = headers['user-agent']
		crawl = agent.indexOf( "Googlebot" ) >= 0 || agent.indexOf( "curl" ) >= 0

		uri = url.parse( request.url ).pathname
		filename = path.join( @root, uri )

		fs.exists filename, (exists)=>

			if !exists || fs.lstatSync( filename ).isDirectory()

				filename = path.join( @root, "/index.html" )
				file = fs.readFileSync( filename , "utf-8")
				response.writeHead 200, {"Content-Type": "text/html"}

				if crawl is true
					cache = pn "#{@root}/static/#{request.url}/index.html"
					if fs.existsSync cache
						src = fs.readFileSync cache
						response.writeHead 200, {"Content-Type": "text/html"}
						response.write "#{src}\n"
						response.end()
					else
						console.log "TODO: implement on-demmand cache"
				else
					response.write file
					response.end()
				return


			fs.readFile filename, "binary", (err, file)->
				if err
					response.writeHead 500, {"Content-Type": "text/plain"}
					response.write err + "\n"
					response.end()
					return

				if filename.match /.js$/m
					response.writeHead 200, {"Content-Type": "text/javascript"}
				else if (mime = filename.match /(jpg|png|gif)$/m)
					response.writeHead 200, {"Content-Type": "image/#{mime[1]}"}
				else if filename.match /.css$/m
					response.writeHead 200, {"Content-Type": "text/css"}

				response.write file, "binary"
				response.end()