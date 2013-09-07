istanbul = require 'istanbul-middleware'
express = require 'express'
path = require 'path'
fs = require 'fs'
url = require 'url'

root = path.join __dirname, '..', 'probatus', 'public'
index = path.join root, 'index.html'


matcher = (req)->
    parsed = url.parse req.url
    return parsed.pathname.match /www\/src\/theoricus/

exports.start = (coverage)->
  if coverage
    istanbul.hookLoader __dirname, verbose: true

  app = do express

  if coverage
    app.use '/coverage', istanbul.createHandler verbose: true, resetOnGet: true
    app.use istanbul.createClientHandler root, matcher: matcher
    app.use express.static root
  else
    app.use express.static root

  app.use (req, res)->
    if ~(req.url.indexOf '.')
      res.statusCode = 404
      res.end 'File not found: ' + req.url
    else
      res.end (fs.readFileSync index, 'utf-8')
  app.use app.router
  app.listen 8080