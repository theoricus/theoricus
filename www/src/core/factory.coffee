#<< theoricus/mvc/*

class theoricus.core.Factory

  {Model,View,Controller} = theoricus.mvc

  controllers: {}

  ###
  @param [theoricus.Theoricus] @the   Shortcut for app's instance
  ###
  constructor:( @the )->

  _is =( src, comparison )->
    while src = src.__proto__
      return true if src instanceof comparison
      src = src.__proto__
    return false

  @model=@::model=( name, init = {} )->
    # console.log "Factory.model( '#{name}' )"


    classname = theoricus.utils.StringUtil.camelize name
    classpath = "app.models.#{name}"

    unless (klass = app.models[ classname ])?
      console.error 'Model not found: ' + classpath
      console.error 'just tried classname: ' + classname
    else
      unless ( model = new klass(init) ) instanceof Model
        console.error "#{classpath} is not a Model instance - you probably forgot to extend thoricus.mvc.Model"
    
    # defaults to AppModel if given model is  is not found
    # (cant see any sense on this, will probably be removed later)
    model = new app.AppModel(init) unless model?

    model.classpath = classpath
    model.classname = classname
    model[prop] = value for prop, value of init

    # console.log "----------------- MODEL"
    # console.log model
    # console.log "-----------------"

    model

  ###
  Returns an instantiated [theoricus.mvc.View] View

  @param [String] path  path to the view file
  @param [theoricus.core.Process] process process responsible for the view
  ###
  view:( path, process = null )->
    # console.log "Factory.view( '#{path}' )"

    klass = app.views
    classpath = "app.views"
    classname = (parts = path.split '/').pop()
    classname = theoricus.utils.StringUtil.camelize classname

    len = parts.length - 1
    namespace  = parts[ len ]

    while parts.length
      classpath += "." + (p = parts.shift())

      if klass[p]?
        klass = klass[p]
      else
        console.error "Namespace '#{p} not found in app.views..."


    classpath += "." + classname

    unless (klass = klass[ classname ])?
      console.error 'View not found: ' + classpath
    else 
      unless (view = new (klass)) instanceof View
        console.error "#{classpath} is not a View instance - you probably forgot to extend thoricus.mvc.View"

    # defaults to AppView if given view is not found
    # (cant see any sense on this, will probably be removed later)
    view = new app.AppView unless view?

    view._boot @the
    view.classpath = classpath
    view.classname = classname
    view.namespace = namespace
    view.process  = process if process?

    # console.log "----------------- VIEW"
    # console.log view
    # console.log "-----------------"

    view

  ###
  Returns an instantiated [theoricus.mvc.Controller] Controller

  @param [String] name  controller name
  ###
  controller:( name )->
    # console.log "Factory.controller( '#{name}' )"

    classname = classname = theoricus.utils.StringUtil.camelize name
    classpath = "app.controllers.#{classname}"

    if @controllers[ classname ]?
      return @controllers[ classname ]
    else

      unless (klass = app.controllers[ classname ])?
        console.error 'Controller not found: ' + classpath

      unless (controller = new (klass)) instanceof Controller
        console.error "#{classpath} is not a Controller instance - you probably forgot to extend thoricus.mvc.Controller"

      controller.classpath = classpath
      controller.classname = classname
      controller._boot @the

      # console.log "----------------- CONTROLLER"
      # console.log controller
      # console.log "-----------------"

      @controllers[ classname ] = controller

  ###
  Returns a compiled jade template

  @param [String] path  path to the template
  ###
  @template=@::template=( path )->
    # console.log "Factory.template( #{path} )"
    if app.templates[path]?
      return app.templates[path]

    console.error "Template ( " + path + " ) doesn't exit"
    null