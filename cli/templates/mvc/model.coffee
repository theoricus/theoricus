AppModel = require 'app/models/app_model'

module.exports = class ~NAME_CAMEL extends AppModel

  ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    MODEL PROPERTIES
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

  # @fields
  #   'id'   : Number
  #   'name' : String
  #   'age'  : Number



  ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RESTFULL JSON SPECIFICATION
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

  # @rest
  #   'all'    : ['GET', '/~CONTROLLER_LC.json']
  #   'create' : ['POST','/~CONTROLLER_LC.json']
  #   'read'   : ['GET', '/~CONTROLLER_LC/:id.json']
  #   'update' : ['PUT', '/~CONTROLLER_LC/:id.json']
  #   'delete' : ['DELETE', '/~CONTROLLER_LC/:id.json']