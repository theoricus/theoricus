Config = require 'theoricus/config/config'
Factory = require 'theoricus/core/factory'
Processes = require 'theoricus/core/processes'

require 'inflection'
require 'jquery'
require 'json'

class Theoricus
  app: null

  # base path for your application
  # in case it runs in a subfolder
  base_path: ''

  root: null

  factory  : null
  config   : null
  processes: null

  crawler: (window.crawler = is_rendered: false)

  constructor: ->
    @config  = new Config @
    @factory = new Factory @

  start: ->
    @processes = new Processes @