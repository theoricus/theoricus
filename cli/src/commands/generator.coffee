Model = require '../generators/model'
Controller = require '../generators/controller'
View = require '../generators/view'

Question = require '../generators/question'

module.exports = class Generator extends Question
  log_changes: true

  constructor:( @the, @cli, type, name, @repl )->
    return unless do @the.is_theoricus_app

    if @cli is null
      @cli = argv: generate: type, _:[name]

    do @create

  create:->
    if @cli.argv.generate is true
      q = "Which you would like to create? [model|view|controller|mvc] : "
      f = /(model|view|controller|mvc)/

      return @ask q, f, (type) =>
        @cli.argv.generate = type
        do @create

    type = @cli.argv.generate
    unless @[type]?
      error_msg = "Valid options: controller, model, view, mvc."

      if @repl

      else
        return console.error error_msg

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
    @view "#{name}/index", true
    @controller name

  model:( name )->
    new Model @the, name, @repl

  view:( path, mvc = false )->
    folder = (parts = path.split '/')[0]
    name   =  parts[1]

    unless name?
      error_msg = 'ERROR '.bold.red + """
        Views should be added with path-style notation.
        
        Usage:
          the -g view <controller-name>/<view-name>

        Examples:
          the -g view users/index
          the -g view users/list

        (*)
          Remember that controller names are plural.
          View names are singular.
      """

      return console.log error_msg

    new View @the, name, folder, mvc, @repl

  controller:( name )->
    new Controller @the, name, @repl