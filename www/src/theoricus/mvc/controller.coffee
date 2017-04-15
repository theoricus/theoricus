###*
  MVC module
  @module mvc
###

Model = require 'theoricus/mvc/model'
View = require 'theoricus/mvc/view'
Fetcher = require 'theoricus/mvc/lib/fetcher'

###*
  The controller is responsible for rendering the {{#crossLink "View"}} __view__ {{/crossLink}}.

  The controller actions are mapped with the {{#crossLink "Route"}} __routes__ {{/crossLink}} in the application's `routes` file.

  Each action receives the URL params, to be used for {{#crossLink "Model"}} __Model__ {{/crossLink}} instantiation.

  @class Controller
###
module.exports = class Controller

  ###
  @param [theoricus.Theoricus] @the   Shortcut for app's instance
  ###
  ###*
    This function is executed by the {{#crossLink "Factory"}} __Factory__ {{/crossLink}}. It saves a `@the` reference inside the controller.

    @method _boot
    @param @the {Theoricus} Shortcut for app's instance
  ###
  _boot: ( @the ) -> @

  ###*
    Build a default action ( renders the {{#crossLink "View"}} __view__ {{/crossLink}} passing all {{#crossLink "Model"}} __model__ {{/crossLink}} records as data) in case the controller doesn't have an action implemented for the current {{#crossLink "Process"}} __process__ {{/crossLink}} call.

    @method _build_action
    @param process {Process} Current {{#crossLink "Process"}}{{/crossLink}} being executed.
  ###
  _build_action: ( process ) ->
    ( params, fn )=>
      controller_name = process.route.controller_name
      action_name = process.route.action_name

      model_name = controller_name.singularize()
      @the.factory.model model_name, null, (model)=>
        return unless model?

        view_folder = controller_name
        view_name   = action_name

        if model.all?
          @render "#{view_folder}/#{view_name}", model.all()
        else
          @render "#{view_folder}/#{view_name}"

  ###*
    Responsible for rendering the {{#crossLink "View"}} __View__ {{/crossLink}}.

    Usually, this method is executed in the controller action mapped with the {{#crossLink "Route"}} __route__ {{/crossLink}}.
    
    @method render
    @param path {String} {{#crossLink "View"}} __View's__ {{/crossLink}} file path. 
    @param data {Object} Data to be passed to the {{#crossLink "View"}} __view__ {{/crossLink}}, usually a {{#crossLink "Model"}} __Model__ {{/crossLink}} instance. 

    @example
        index:(id)-> # Controller action
            render "app/views/index", Model.first()
  ###
  render:( path, data )->
    @the.factory.view path, (view)=>
      return unless view?

      @process.view = view

      view.process = @process
      view.after_in = @after_render

      if data instanceof Fetcher
        if data.loaded
          view._render data.records
        else
          data.onload = ( records ) =>
            view._render records
      else
        view._render data


  # ~> Shortcuts

  ###*
    Shortcut for application navigate.

    Navigate to the given URL.

    @method navigate
    @param url {String} URL to navigate to.
  ###
  navigate:( url )->

    # if redirect is called during the action execution, some operations must to
    # be performed in order to effectively kill the running process prematurely
    # before the router's navigation gets called
    # 
    # for this to work, your @render method must not be called, ie:
    # 
    # action:->
    #   if user_is_logged
    #     return @redirect '/signin'
    #   @render '/signedin'
    # 
    if @process.is_in_the_middle_of_running_an_action

      # kill current running process
      @process.processes.active_processes.pop()
      @process.processes.pending_processes = []

      # fires after_render prematurely to wipe the fresh glue
      @after_render()

    # and redirects user
    @the.processes.router.navigate url