http = require "http"
url  = require "url"
fs   = require "fs"
path = require "path"
pn   = path.normalize
conn = require 'connect'

exec = require( "child_process" ).exec

Compiler = require './compiler'

module.exports = class Server
  @socket = null

  constructor:( @the, options )->
    @port = options[1] or 11235
    @root = "#{@the.pwd}/public"

    # console.log  "Server is born()"
    @start_server()
    @compiler = new Compiler @the, true

  start_server:()->
    @server = conn()
                .use(conn.static @root )
                .use( (req, res)->
                  res.end (fs.readFileSync "#{@root}/index.html", 'utf-8')
                ).listen @port

    @socket = (require "socket.io").listen @server
    @socket.sockets.on "connection", (socket) ->
      console.log 'client connected'

    console.log "#{'Server running at'.bold} http://localhost:#{@port}".grey

  close_server:()->
    @server.close()