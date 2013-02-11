Model = require 'theoricus/mvc/model'
View = require 'theoricus/mvc/view'
Fetcher = require 'theoricus/mvc/lib/fetcher'

class Controller

  ###
  @param [theoricus.Theoricus] @the   Shortcut for app's instance
  ###
  _boot: ( @the ) -> @

  ###
  Build a default action ( renders the view passing all model records as data)
  in case the controller doesn't have an action for current process call

  @param [theoricus.core.Process] process path to view on the app tree
  ###
  _build_action: ( process ) ->
    =>
      api = process.route.api

      model_name = api.controller_name.singularize().camelize()
      model      = app.models[model_name]

      view_folder = api.controller_name.singularize()
      view_name   = api.action_name

      if model.all?
        @render "#{view_folder}/#{view_name}", model.all()
      else
        @render "#{view_folder}/#{view_name}", null

  ###
  Renders view

  @param [String] path  path to view on the app tree
  @param [String] data  data to be rendered on the template
  @param [Object] element element where it will be rendered, defaults to @process.route.el
  ###
  render: ( path, data, el = @process.route.el, view ) ->
    if view?
      @_render_view path, data, el, view
    else
      @the.factory.view path, @process, ( view )->
        @_render_view path, data, el, view

  _render_view:( path, data, el = @process.route.el )->
    view.after_in = view.process.after_run

    if data instanceof Fetcher
      if data.loaded
        view.render data.records, el
      else
        data.onload = ( records ) =>
          @render path, records, el, view
    else
      view.render data, el

    view