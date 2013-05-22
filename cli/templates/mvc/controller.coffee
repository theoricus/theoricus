AppController = require 'app/controllers/app_controller'
~MODEL_CAMEL = require 'app/models/~MODEL_LCASE'

module.exports = class ~NAME_CAMEL extends AppController

  ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    DEFAULT ACTION BEHAVIOR
    Override it to take control and customize as you wish
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

  # <action-name>:()->
  #   if ~MODEL_CAMEL.all?
  #     @render "~NAME_LC/<action-name>", ~MODEL_CAMEL.all()
  #   else
  #     @render "~NAME_LC/<action-name>", null

  ### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    EXAMPLES
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

  # list:()->
  #   @render "~NAME_LC/list", ~MODEL_CAMEL.all()

  # create:()->
  #   @render "~NAME_LC/create", null