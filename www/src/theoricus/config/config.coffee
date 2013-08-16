###*
  Config module
  @module config
###

###*
  Config class.
  @class Config
###
module.exports = class Config

  ###*
    If true, execute the __default__ {{#crossLink "View"}} __view's__ {{/crossLink}} transitions at startup, otherwise, skip them and render the views without transitions.

    @property {Boolean} animate_at_startup
  ###
  animate_at_startup: false

  ###*
    If true, automatically insert __default__ fadeIn/fadeOut transitions for the {{#crossLink "View"}} __views__ {{/crossLink}}.

    @property {Boolean} enable_auto_transitions
  ###
  enable_auto_transitions: true

  ###*
    If true, skip all the {{#crossLink "View"}} __view's__ {{/crossLink}} __default__ transitions.

    @property {Boolean} disable_transitions
  ###
  disable_transitions: null

  ###*
  Config constructor, initializing the app's config settings defined in `settings.coffee`

  @class Config
  @constructor
  @param the {Theoricus} Shortcut for app's instance
  @param Settings {Object} App settings defined in the `settings.coffee`.
  ###
  constructor:( @the, @Settings )->
    @disable_transitions = @Settings.disable_transitions ? false
    @animate_at_startup = @Settings.animate_at_startup ? true
    @enable_auto_transitions = @Settings.enable_auto_transitions ? true
    @autobind = @Settings.autobind ? false
    @vendors = @Settings.vendors
