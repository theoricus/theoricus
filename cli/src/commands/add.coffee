Model = require '../generators/model'
Controller = require '../generators/controller'
View = require '../generators/view'

Question = require '../generators/question'

module.exports = class Add extends Question

  constructor:( @the, @opts )->
    do @create

  create: ()->

    if @opts[1]?
      type = @opts[1]
    else
      q = "Which you would like to create? [controller|model|view|mvc] : "
      f = /(controller|model|view|mvc)/

      return @ask q, f, (type) =>
        @opts[1] = type
        do @create

    if @opts[2]?
      name = @opts[2]
    else
      q = "Please give it a name : "
      f = /([^\s]*)/ # not empty

      return @ask q, f, (name) =>
        @opts[2] = name
        do @create

    args = @opts.slice 3

    unless @[type]?
      error_msg = "Valid options: controller, model, view, mvc."
      throw new Error error_msg

    @[type]( name, args )

  mvc:( name, args )->
    @model name.singularize(), args
    @view "#{name.singularize()}/index"
    @controller name

  model:( name, args )->
    new Model @the, name, args, @opts

  view:( path )->
    folder = (parts = path.split '/')[0]
    name   =  parts[1]

    unless name?
      error_msg = """
        Views should be added with path-style notation.\n
        \ti.e.:
        \t\t theoricus add view person/index
        \t\t theoricus add view user/list\n
      """
      throw new Error error_msg
      return

    new View @the, name, folder, false, @opts

  controller:( name )->
    new Controller @the, name, @opts