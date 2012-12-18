class theoricus.commands.StaticServer
	HTTPServer = require "http-server"

	constructor:( @the, options )->
		@port = if options[1]? then options[1] else "11235"
		@root = "#{@the.pwd}/public/static"

		server = HTTPServer.createServer
			root: @root
			port: @port
			autoIndex: true

		server.listen @port, "0.0.0.0", =>
			msg = "#{'Static server running at'.bold} http://localhost:#{@port}".grey
			console.log msg