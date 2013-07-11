path = require 'path'
fork = (require 'child_process' ).fork
colors = require 'colors'
http = require 'http'
argv = (require 'optimist').argv

polvo = null

# start/stop polvo
start = exports.start = ( after_start ) ->

  console.log 'Starting Polvo\n'.bold.grey

  polvo_path = path.join __dirname, '..', '..', '..', 'node_modules'
  polvo_path = path.join polvo_path, 'polvo', 'bin', 'polvo'
  probatus = path.join __dirname, '..', 'probatus'

  polvo = fork polvo_path, ['-rs'], cwd: probatus
  polvo.on 'message', (data)=>
    switch data.channel
      when 'stdout' then console.log data.msg
      when 'stderr' then console.log data.msg
      else
        if data.msg is 'server.started'
          after_start?()

stop = exports.stop = ->
  console.log 'Stopping Polvo\n'.bold.grey
  do polvo?.kill



# startup and shutdown over socket
listen_for_shutdown = ->
  io = get_socket_io false

  server = do http.createServer
  conn = io.listen server, 'log level': 0
  server.listen 3001

  conn.on 'connection', (socket)->
    socket.on 'shutdown', ( data )->
      do socket.disconnect
      do process.exit

emit_shutdown = ->
  io = get_socket_io true
  conn = io.connect '127.0.0.1:3001'
  conn.on 'connect', -> conn.emit 'shutdown'

get_socket_io = ( client ) ->
  root = path.join __dirname, '..', '..', '..'
  polvo_modules = path.join root, 'node_modules', 'polvo', 'node_modules'
  sio = path.join polvo_modules, 'socket.io'

  if client
    sio = path.join sio, 'node_modules', 'socket.io-client'
    sio = path.join sio, 'lib', 'io'
  else
    sio = path.join sio, 'index'

  require sio


# auto start / shutdown
if argv.start
  start null
  do listen_for_shutdown

else if argv.stop
  do emit_shutdown