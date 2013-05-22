Model = require '../generators/model'
Controller = require '../generators/controller'
View = require '../generators/view'

Question = require '../generators/question'

module.exports = class Add extends Question

  constructor:( @the, @cli )->
    return unless do @the.is_theoricus_app
    do @create

  create: ()->

    if @cli.argv.generate is true
      q = "Which you would like to create? [model|view|controller|mvc] : "
      f = /(model|view|controller|mvc)/

      return @ask q, f, (type) =>
        @cli.argv.generate = type
        do @create

    type = @cli.argv.generate
    unless @[type]?
      error_msg = "Valid options: controller, model, view, mvc."
      throw new Error error_msg

    name = @cli.argv._[0]
    unless name?
      q = "Please give it a name : "
      f = /([^\s]*)/ # not empty

      return @ask q, f, (name) =>
        @cli.argv._ = [name]
        do @create

    @[type]( name )

  mvc:( name )->
    @model name.singularize()
    @view "#{name.singularize()}/index"
    @controller name

  model:( name )->
    new Model @the, name, @cli

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

    new View @the, name, folder, false, @cli

  controller:( name )->
    new Controller @the, name, @cli