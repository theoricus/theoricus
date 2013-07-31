###*
  MVC module
  @module mvc
###

Model = require 'theoricus/mvc/model'
Factory = null

###*
  @class View
###
module.exports = class View

  # @property page title
  ###*
    Sets the title of the document.

    @property title {String}
  ###
  title: null

  ###*
    The template's html as jQuery object.

    @property el {Object}
  ###
  el: null

  # @property [String] class path
  ###*
   File's path relative to the app's folder.

   @property classpath {String}
  ###
  classpath : null

  # @property [String] class name
  ###*
    Stores class name

    @property classname {String}
  ###
  classname : null

  ###*
    Namespace is the class folder path relative to the views folder.

    @property namespace {String}
  ###
  namespace : null
  
  ###*
    {{#crossLink "Process"}}{{/crossLink}} responsible for running the controller's action that rendered this view.

    @property process {Process}
  ###
  process   : null

  ###*
    Responsible for binding the DOM events on the view. Use the format `selector event: handler` to define an event.

    @property events {Object}
    @example
        events:  
            ".bt-alert click":"on_alert"

  ###
  events    : null

  ###*
    Responsible for storing the template's data and the URL params.
    
    @property data {Object}
  ###
  data      : null

  ###*
    This function is executed by the Factory. It saves a `@the.factory` reference inside the view.

    @method _boot
    @param @the {Theoricus} Shortcut for app's instance
  ###
  _boot:( @the )->
    Factory = @the.factory
    @

  ###*
    Responsible for rendering the view, passing the data to the `template`.

    @method _render
    @param data {Object} Data object to be passed to the template, usually it is and instance of the {{#crossLink "Model"}}{{/crossLink}}
    @param [template=null] {String} The path of the template to be rendered.
  ###
  _render:( data = {}, template )=>
    @data = 
      view: @
      params: @process.params
      data: data

    @before_render?(@data)

    @process.on_activate = =>
      @on_activate?()
      if @title?
        document.title = @title

    @el = $ @process.route.el

    unless template?
      tmpl_folder = @namespace.replace(/\./g, '/')
      tmpl_name   = @classname.underscore()
      template = "#{tmpl_folder}/#{tmpl_name}"

    @render_template template

  ###*
    If there is a `before_render` method implemented, it will be executed before the view's template is appended to the document.

    @method before_render
    @param data {Object} Reference to the `@data`
  ###


  ###*
    Responsible for loading the given template, and appending it to {{#crossLink "View"}}{{/crossLink}} `el` element.

    @method render_template
    @param template {String} Path to the template to be rendered.
  ###
  render_template:( template )->
    @the.factory.template template, ( template ) =>

      dom = template @data
      dom = @el.append dom

      # binds item if the data passed is a valid Model
      if (@data instanceof Model)
        @data.bind dom, !@the.config.autobind
      
      @set_triggers?()
      @after_render?(@data)

      @in()

      if @on_resize?
        $( window ).unbind 'resize', @_on_resize
        $( window ).bind   'resize', @_on_resize
        @on_resize()

  ###*
    If there is an `after_render` method implemented, it will be executed after the view's template is appended to the document. Useful for caching DOM elements as jQuery objects.

    @method after_render
    @param data {Object} Reference to the `@data`
  ###

  ###*
    If there is an `@on_resize` method implemented, it will be executed whenever the window triggers the `scroll` event.

    @method on_resize
  ###
  _on_resize:=>
    do @on_resize

  ###*
    Process the `@events`, automatically binding them.

    @method set_triggers
  ###
  set_triggers: () =>
    return if not @events?
    for sel, funk of @events
      [all, sel, ev] = sel.match /(.*)[\s|\t]+([\S]+)$/m
      ( @el.find sel ).unbind ev, null, @[funk]
      ( @el.find sel ).bind   ev, null, @[funk]

  ###*
    If there is a `@before_in` method implemented, it will be called before the view execute it's intro animations. Useful to setting up the DOM elements properties before animating them.

    @method before_in    
  ###

  ###*
    The `in` method is where the view intro animations are defined. It is executed after the `@after_render` method.

    The `@after_in` method must be called at the end of the animations, to Theoricus knows that the View finished animating.

    @method in
  ###
  in:()->
    @before_in?()
    animate  = @the.config.enable_auto_transitions
    animate &= !@the.config.disable_transitions
    unless animate
      @after_in?()
    else
      @el.css "opacity", 0
      @el.animate {opacity: 1}, 300, => @after_in?()

  ###*
    If there is an`@after_in` method implemented, it will be called after the view finish it's intro animations.

    Will only be executed if the {{#crossLink "Config"}}{{/crossLink}} property `disable_transitions` is `false`.

    @method after_in    
  ###

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
      $( window ).unbind 'resize', @_on_resize

    @before_destroy?()
    @el.empty()

  # ~> Shortcuts

  ###
  Shortcut for application navigate

  @param [String] url URL to navigate
  ###
  navigate:( url )->
    @the.processes.router.navigate url