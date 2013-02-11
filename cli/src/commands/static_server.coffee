conn = require "connect"

module.exports = class StaticServer

  constructor:( @the, options )->
    @port = options[1] or 11235
    @root = "#{@the.pwd}/public/static"

    server = conn()
              .use(conn.static @root )
              .use( (req, res)->
                res.end (fs.readFileSync "#{@root}/index.html", 'utf-8')
              ).listen @port

    msg = "#{'Static server running at'.bold} http://localhost:#{@port}".grey
    console.log msg