http = require "http"
url = require "url"
path = require "path"
fs = require "fs"
exec = require( "child_process" ).exec
port = process.argv[2] || 8888
root = process.argv[3] || "/public"

server = (request, response)->

	headers = request.headers
	agent = headers['user-agent']
	crawl = agent.indexOf( "Googlebot" ) >= 0 || agent.indexOf( "curl" ) >= 0

	uri = url.parse( request.url ).pathname
	filename = path.join( process.cwd() + root, uri )

	path.exists filename, (exists)->

		if !exists || fs.lstatSync( filename ).isDirectory()

			filename = process.cwd() + root + "/index.html"
			file = fs.readFileSync( filename , "utf-8")
			response.writeHead 200, {"Content-Type": "text/html"}

			if crawl is true
				cmd = "phantomjs crawler.coffee http://"+
						headers.host +
						request.url +
						"?crawler"
				exec cmd, (error, stdout, stderr)->
					response.writeHead 200, {"Content-Type": "text/html"}
					response.write stdout
					response.end()
			else
				response.write file
				response.end()
			return

		fs.readFile filename, "utf-8", (err, file)->
			if err
				response.writeHead 500, {"Content-Type": "text/plain"}
				response.write err + "\n"
				response.end()
				return
			response.writeHead 200, {"Content-Type": "text/javascript"}
			response.write file
			response.end()

http.createServer( server ).listen port

console.log(
	"Theoricus ridiculous server running at... http://localhost:" +
	port + "/\nCTRL + C to shutdown"
)