Model = require 'theoricus/mvc/model'
Factory = null

module.exports = class View

  # $ reference to dom element
  el: null

  # @property [String] class path
  classpath : null

  # @property [String] class name
  classname : null

  # @property [String] namespace
  namespace : null
  
  # @property [theoricus.core.Process] process
  process   : null

   ###
  @param [theoricus.Theoricus] @the   Shortcut for app's instance
  ###
  _boot:( @the )->
    Factory = @the.factory
    @

  ###
  @param [Object] @data   Data to be passed to the template
  @param [Object] @el     Element where the view will be "attached/appended"
  ###
  render:( @data = {}, el = @process.route.el, template = null )=>
    @before_render?(@data)

    if not @el
      api = @process.route.api
      @el = $ el

      if template == null
        tmpl_folder = @namespace.replace(/\./g, '/')
        tmpl_name   = @classname.underscore()

        @template "#{tmpl_folder}/#{tmpl_name}", ( template ) =>
          @render_template template

   render_template:( template )->
    dom = template @data if template?
    dom = @el.append dom

    # binds item if the data passed is a valid Model
    if (@data instanceof Model)
      @data.bind dom, !@the.config.autobind
    
    @in()
    @set_triggers?()
    @after_render?(@data)
    
    if @on_resize?
      $( window ).unbind 'resize', @on_resize
      $( window ).bind   'resize', @on_resize
      @on_resize()


  ###
  TODO: Document method.
  ###
  require: ( view, container, data = @data, template, fn ) ->
    @view view, ( view )=>
      if container
        view.render data, @el.find container, template

      fn view
  
  ###
  In case you defined @events in your view they will be automatically binded
  ###
  set_triggers: () =>
    return if not @events?
    for sel, funk of @events
      [all, sel, ev] = sel.match /(.*)[\s|\t]+([\S]+)$/m
      ( @el.find sel ).unbind ev, null, @[funk]
      ( @el.find sel ).bind   ev, null, @[funk]

  ###
  Called before completely erasing the view
  ###
  destroy: () ->
    @before_destroy?()
    @el.empty()

  ###
  Triggers view "animation in", "@after_in" must be called in the end
  ###
  in:()->
    @before_in?()
    animate  = @the.config.enable_auto_transitions
    animate &= !@the.config.disable_transitions
    unless animate
      @after_in?()
    else
      @el.css "opacity", 0
      @el.animate {opacity: 1}, 600, => @after_in?()

  ###
  Triggers view "animation out", "after_out" must be called in the end
   @param [Function] after_out Callback function to be triggered in the end
  ###
  out:( after_out )->
    @before_out?()
    animate = @the.config.enable_auto_transitions
    animate &= !@the.config.disable_transitions
    unless animate
      after_out()
    else
      @el.animate {opacity: 0}, 300, after_out

  ###
  Destroy the view after the 'out' animation, the default behavior is to just
  empty it's container element.

  before_destroy will be called just before emptying it.
  ###
  destroy: () ->
    if @on_resize?
      $( window ).unbind 'resize', @on_resize

    @before_destroy?()
    @el.empty()

  # ~> Shortcuts

  ###
  Shortcut for application navigate

  @param [String] url URL to navigate
  ###
  navigate:( url )->
    @the.processes.router.navigate url

  ###
  Shortcut for Factory.view method

  @param [String] path    Path to view file
  ###
  view:( path, fn )->
    Factory.view path, @process, fn

  ###
  Shortcut for Factory.template method

  @param [String] url Path to template file
  ###
  template:( path, fn )->
    Factory.template path, fn

  ###
  instantiates a view, render on container passing current data
  ###
  require: ( view, container, data = @data, template ) ->
    view = @view view, ( view ) =>

      if container

        # if user passes a selector instead of a object
        if container instanceof String
          container = @el.find container

        # if user passes an object ref, jQuerify it 
        unless container instanceof jQuery
          container = $ container

        view.render data, @el.find container, template

      view

  find: ( selector ) => @el.find selector

  ###
  Takes a selector or array of selectors
  Adds click event handler to each of them
  ###
  link: ( a_selector ) ->

    $( a_selector ).each ( index, selector ) =>
      @find( selector ).click ( event ) =>

        @navigate $( event.delegateTarget ).attr( 'href' )

        return off