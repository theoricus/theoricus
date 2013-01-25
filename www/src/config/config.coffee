class theoricus.config.Config

  animate_at_startup: false
  enable_auto_transitions: true

  app_name: null
  no_push_state: null
  disable_transitions: null

  ###
  @param [theoricus.Theoricus] @the   Shortcut for app's instance
  ###
  constructor:( @the )->
    @app_name = "app"

    @disable_transitions = app.config.disable_transitions ? false
    @animate_at_startup = app.config.animate_at_startup ? true
    @enable_auto_transitions = app.config.enable_auto_transitions ? true
    @autobind = app.config.autobind ? false
    @vendors = app.config.vendors
