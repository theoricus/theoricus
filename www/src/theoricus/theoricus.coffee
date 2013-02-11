#<< theoricus/*

class theoricus.Theoricus
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
    @config  = new theoricus.config.Config @
    @factory = new theoricus.core.Factory @

  start: ->
    @processes = new theoricus.core.Processes @