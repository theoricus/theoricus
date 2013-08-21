###*
  Core module
  @module core
###

Model = require 'theoricus/mvc/model'
View = require 'theoricus/mvc/view'
Controller = require 'theoricus/mvc/controller'

###*
  Factory is responsible for loading/creating the MVC classes, templates and stylesheets using AMD loader.

  @class Factory
###

module.exports = class Factory

  ###*
    Stores the loaded controllers for subsequent calls.
    @property controllers {Array}
  ###
  controllers: {}

  ###*
  @class Factory
  @constructor
  @param the {Theoricus} Shortcut for app's instance
  ###
  constructor:( @the )->
    # sets the Factory inside Model class, statically
    Model.Factory = @

  ###*
  Loads and returns an instantiated {{#crossLink "Model"}} __Model__ {{/crossLink}} given the name. 

  If a model by given name was not found, returns an instance of `AppModel`.

  @method model
  @param name {String} Model name.
  @param init {Object} Default properties to be setted in the model instance.
  @param fn {Function} Callback function returning the model instance.
  ###
  @model=@::model=( name, init = {}, fn )->
    # console.log "Factory.model( '#{name}' )"

    classname = name.camelize()
    classpath = "app/models/#{name}".toLowerCase()

    if (ModelClass = require classpath) is null
      console.error "Model not found '#{classpath}'"
      return fn null

    unless (model = new ModelClass) instanceof Model
      msg = "#{classpath} is not a Model instance, you probably forgot to "
      msg += "extend thoricus/mvc/Model"
      console.error msg
      return fn null

    model.classpath = classpath
    model.classname = classname
    model[prop] = value for prop, value of init

    fn model

  ###*
  Loads and returns an instantiated {{#crossLink "View"}} __View__  {{/crossLink}} given the name. 

  If a {{#crossLink "View"}} __view__  {{/crossLink}} by given name was not found, returns an instance of `AppView`.

  @method view
  @param path {String} Path to the view file.
  @param fn {Function} Callback function returning the view instance.
  ###
  view:( path, fn )->
    # console.log "Factory.view( '#{path}' )"

    classname = (parts = path.split '/').pop().camelize()
    namespace = parts[parts.length - 1]
    classpath = "app/views/#{path}"

    if (ViewClass = require classpath) is null
      console.error "View not found '#{classpath}'"
      return fn null

    unless (view = new ViewClass) instanceof View
      msg = "#{classpath} is not a View instance, you probably forgot to "
      msg += "extend thoricus/mvc/View"
      console.error msg
      return fn null

    # defaults to AppView if given view is not found
    # (cant see any sense on this, will probably be removed later)
    view = new AppView unless view?

    view._boot @the
    view.classpath = classpath
    view.classname = classname
    view.namespace = namespace

    fn view


  ###*
  Returns an instantiated {{#crossLink "Controller"}}__Controller__{{/crossLink}} given the name.

  If the {{#crossLink "Controller"}}__controller__{{/crossLink}} was not loaded yeat, load it using AMD loader, otherwise, get it from `@controllers` object.

  Throws an error if no controller is found.

  @method controller
  @param name {String} Controller name.
  @param fn {Function} Callback function returning the controller instance.
  ###
  controller:( name, fn )->
    # console.log "Factory.controller( '#{name}' )"

    classname = name.camelize()
    classpath = "app/controllers/#{name}"

    if @controllers[ classpath ]?
      fn @controllers[ classpath ]
    else

      if (ControllerClass = require classpath) is null
        console.error "Controller not found '#{classpath}'"
        return fn null

      unless (controller = new ControllerClass) instanceof Controller
        msg = "#{classpath} is not a Controller instance, you probably "
        msg += "forgot to extend thoricus/mvc/Controller"
        console.error msg
        return fn null

      controller.classpath = classpath
      controller.classname = classname
      controller._boot @the

      @controllers[ classpath ] = controller
      fn @controllers[ classpath ]

  ###*
  Returns an AMD compiled template.

  @method template
  @param path {String} Path to the template.
  @param fn {Function} Callback function returning the template string.

  @example

  ###
  @template=@::template=( path, fn )->
    # console.log "Factory.template( #{path} )"
    classpath = 'templates/' + path

    if (template = require classpath) is null
      console.error 'Template not found: ' + classpath
      return fn null
    
    fn template