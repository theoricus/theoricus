###*
  Core module
  @module core
###

StringUtil = require 'theoricus/utils/string_util'
View = require 'theoricus/mvc/view'

###*
  Responsible for executing the {{#crossLink "Controller"}}__controller__{{/crossLink}} render action based on the {{#crossLink "Route"}}__Route__{{/crossLink}} information.

  @class Process
###
module.exports = class Process

  ###*
  {{#crossLink "Controller"}}__Controller__{{/crossLink}} instance, responsible for rendering the {{#crossLink "View"}}__views__{{/crossLink}} based on the __action__ defined in the {{#crossLink "Route"}}__Route's__{{/crossLink}} {{#crossLink "Route/to:property"}} __to__ {{/crossLink}} property.

  @property {Controller} controller
  ###
  controller: null

  ###*
  {{#crossLink "Route"}}{{/crossLink}} storing the information which will be used load the {{#crossLink "Controller"}}{{/crossLink}} and render the {{#crossLink "View"}} __view__ {{/crossLink}}.
  
  @property {Route} route
  ###
  route: null

  ###*
  Stores the dependency url defined in the {{#crossLink "Route"}}__Route's__{{/crossLink}} {{#crossLink "Route/at:property"}} __at__{{/crossLink}} property.
  
  @property {String} dependency
  ###
  dependency: null

  ###*
  Will be setted to __`true`__ in the __`run`__ method, right before the action execution, and set to __`false`__ right after the action is executed. 

  This way the {{#crossLink "Router/navigate:method"}} __navigate__ {{/crossLink}} method can abort the {{#crossLink "Process"}} __process__ {{/crossLink}} prematurely as needed.
  
  @property {Boolean} is_in_the_middle_of_running_an_action
  ###
  is_in_the_middle_of_running_an_action: false

  ###*
  Stores the {{#crossLink "Route"}} __Route__ {{/crossLink}} parameters.

  @example
  If there is a route defined with a parameter `id` like this:

      '/works/:id': #parameters are defined in the ':{value}' format.
          to: "pages/container"
          at: null
          el: "body"
  
  And the url changes to:

      '/works/1'


  The `params` will stores an `Object` like this:

      {id:1}


  @property {Object} params
  ###
  params: null

  ###*
  @class Process
  @constructor
  @param @the {Theoricus} Shortcut for app's instance.
  @param @processes {Processes} {{#crossLink "Processes"}}__Processes__{{/crossLink}}, responsible for delegating the current {{#crossLink "Route"}}__route__{{/crossLink}} to its respective {{#crossLink "Process"}}__process__{{/crossLink}}.
  @param @route {Route} {{#crossLink "Processes"}}__Route__{{/crossLink}} storing the current URL information.
  @param @at {Route} {{#crossLink "Processes"}}__Route__{{/crossLink}} dependency defined in the {{#crossLink "Route/at:property"}} __at__ {{/crossLink}} property.
  @param @url {String} Current url state.
  @param @parent_process {Process}
  @param fn {Function} Callback to be called after the `dependency` have been setted, and the {{#crossLink "Controller"}}__controller__{{/crossLink}} loaded.
  ###
  constructor:( @the, @processes, @route, @at, @url, @parent_process, fn )->

    # initialize process logic
    do @initialize

    # instantiates controller and fires the constructor callback
    @the.factory.controller @route.controller_name, ( @controller )=>
      fn @, @controller

  ###*
  Evaluates the `@route` dependency.
  
  @method initialize
  ###
  initialize:->
    if @url is null and @parent_process?
      @url = @route.rewrite_url_with_parms @route.match, @parent_process.params

    # initializes params object
    @params = @route.extract_params @url

    # evaluates dependency route
    if @at
      @dependency = @route.rewrite_url_with_parms @at, @params

  ###*
  Executes the {{#crossLink "Controller"}}__controller's__{{/crossLink}} __action__ defined in the {{#crossLink "Route/to:property"}} __to__ {{/crossLink}} property, if it isn't declared executes a default one based on the name convention.
  
  @param after_run {Function} Callback to be called after the view was rendered.
  ###
  run:( after_run )->

    # sets is_in_the_middle_of_running_an_action=true
    @is_in_the_middle_of_running_an_action = true

    # if action is not defined, defines the default action behaviour for it
    unless @controller[ action = @route.action_name ]
      @controller[ action ] = @controller._build_action @

    # inject the current process into controller
    @controller.process = @

    # creates callback to reset things
    @after_run = =>
      @controller.process = null
      after_run()

    # sets the callback
    @controller.after_render = @after_run

    # executes action
    @controller[ action ] @params

    # sets is_in_the_middle_of_running_an_action=false
    @is_in_the_middle_of_running_an_action = false



  ###*
  Executes the {{#crossLink "View"}}__view's__{{/crossLink}} transition {{#crossLink "View/out:method"}} __out__ {{/crossLink}} method, wait for it to empty the dom element and then call the `@after_destroy` callback.
  
  @method destroy
  @param @after_destroy {Function} Callback to be called after the view was removed.
  ###
  destroy:( @after_destroy )->
    # call the OUT transition with the given callback
    unless (@view instanceof View)
      controller_name = @route.controller_name.camelize()
      action_name = @route.action_name
      msg = "Can't destroy View because it isn't a proper View instance. "
      msg += "Check your `#{controller_name}` controller, the action "
      msg += "`#{action_name}` must return a View instance."
      console.error msg
      return

    @view.out =>
      @view.destroy()
      @after_destroy?()