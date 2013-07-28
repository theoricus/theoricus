coverage = require 'istanbul-middleware'
express = require 'express'
path = require 'path'
fs = require 'fs'
url = require 'url'

root = path.join __dirname, '..', 'probatus', 'public'
index = path.join root, 'index.html'

coverage.hookLoader __dirname, { verbose: true }

matcher = (req)->
    # parsed = url.parse req.url
    # return parsed.pathname.match /^js\/theoricus/
    true

app = do express
app.use '/coverage', coverage.createHandler verbose: true, resetOnGet: true
app.use coverage.createClientHandler root
app.use express.static root, matcher: matcher
app.use (req, res)->
  if ~(req.url.indexOf '.')
    res.statusCode = 404
    res.end 'File not found: ' + req.url
  else
    res.end (fs.readFileSync index, 'utf-8')
app.use app.router
app.listen 8080