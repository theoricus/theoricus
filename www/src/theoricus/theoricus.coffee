###*
  Theoricus module
  @module theoricus
###

Config = require 'theoricus/config/config'
Factory = require 'theoricus/core/factory'
Processes = require 'theoricus/core/processes'

require 'inflection'
require 'jquery'
require 'json'


###*
  Theoricus main class.
  @class Theoricus
###
module.exports = class Theoricus

  ###*
    Base path for your application, in case it runs in a subfolder. If not, this
    can be left blank, meaning your application will run in the `web_root` dir
    on your server.

    @property {String} base_path
  ###
  base_path: ''

  ###*
    Instance of {{#crossLink "Factory"}}__Factory__{{/crossLink}} class.
    @property {Factory} factory
  ###
  factory  : null

  ###*
    Instance of {{#crossLink "Config"}}__Config__{{/crossLink}} class, fed by the application's `config.coffee` file.
    @property {Config} config
  ###
  config   : null

  ###*
    Instance of {{#crossLink "Processes"}}__Processes__{{/crossLink}} class, responsible for handling the url change.
    @property {Processes} processes
  ###
  processes: null

  ###*
    Reference to `window.crawler` object, this object contains a property called `is_rendered` which is set to true whenever the current {{#crossLink "Process"}}__process__{{/crossLink}} finishes rendering.

    This object is used specially for server-side indexing of Theoricus's apps, though the use of <a href="http://github.com/serpentem/snapshooter">Snapshooter</a>.
    @property {Crawler} crawler
  ###
  crawler: (window.crawler = is_rendered: false)

  ###*
    Theoricus constructor, must to be invoked by the application with a `super`
    call.
    @class Theoricus
    @constructor
    @param Settings {Object} Settings defined in the application's `config.coffee` file.
    @param Routes {Object} Routes defined in the application's `routes.coffee` file.
  ###
  constructor:( @Settings, @Routes )->
    @config  = new Config @, @Settings
    @factory = new Factory @

  ###*
    Starts the Theoricus engine, plugging the {{#crossLink "Processes"}}__Processes__{{/crossLink}} onto the {{#crossLink "Router"}}__Router__{{/crossLink}} system.
    @method start
  ###
  start: ->
    @processes = new Processes @, @Routes