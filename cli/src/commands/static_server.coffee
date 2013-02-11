HTTPServer = require "http-server"

module.exports = class StaticServer

  constructor:( @the, options )->
    @port = options[1] or 11235
    @root = "#{@the.pwd}/public/static"

    server = HTTPServer.createServer
      root: @root
      port: @port
      autoIndex: true

    server.listen @port, "0.0.0.0", =>
      msg = "#{'Static server running at'.bold} http://localhost:#{@port}".grey
      console.log msg