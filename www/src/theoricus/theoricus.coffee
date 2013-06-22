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
    Instance of Fatory class.
    @property {Factory} factory
  ###
  factory  : null

  ###*
    Instance of Config class, fed by the Settings class.
    @property {Config} config
  ###
  config   : null

  ###*
    Instance of Processes class.
    @property {Processes} processes
  ###
  processes: null

  ###*
    Theoricus constructor, must to be invoked by the application with a `super`
    call.
    @method constructor
    @param @Settings {Object} App Settings
    @param @Routes {Object} App Routes
  ###
  constructor:( @Settings, @Routes )->
    @config  = new Config @, @Settings
    @factory = new Factory @

  ###*
    Starts the Theoricus engine, plugging the Processes onto the Router system.
    @method start
  ###
  start: ->
    @processes = new Processes @, @Routes