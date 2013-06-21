fs = require 'fs'
path = require 'path'

fsu = require "fs-util"


module.exports = class Destroyer

  constructor:( @the, @cli, type, name, rf, @repl )->
    return unless do @the.is_theoricus_app

    if @cli is null
      @cli = argv: _:[name], destroy: type, rf: rf

    type = @cli.argv.destroy
    name = @cli.argv._[0]

    @SRC = "#{@the.pwd}/src"
    @APP_FOLDER = "#{@SRC}/app"
    @TEMPLATES_FOLDER = "#{@SRC}/templates"
    @STYLES_FOLDER = "#{@SRC}/styles"

    unless @[type]?
      error_msg = "Valid options: controller, model, view, mvc."
      (@repl or console).error error_msg

    @[type]( name )

  mvc:( name )->
    @model name.singularize()
    @view "#{name}/index"
    @controller name

  model:( name )->
    @rm "#{@APP_FOLDER}/models/#{name}.coffee"

  view:( path )->
    folder = (parts = path.split '/')[0]
    name = parts[1]

    unless (name? or @cli.argv.rf)
      error_msg = """
        Views should be removed with path-style notation.\n
        \ti.e.:
        \t\t theoricus rm view person/index
        \t\t theoricus rm view user/list\n
      """
      return (@repl or console).error error_msg

    if @cli.argv.rf
      @rm "#{@APP_FOLDER}/views/#{folder}"
      @rm "#{@STYLES_FOLDER}/#{folder}"
      @rm "#{@TEMPLATES_FOLDER}/#{folder}"
    else
      @rm "#{@APP_FOLDER}/views/#{folder}/#{name}.coffee"
      @rm "#{@TEMPLATES_FOLDER}/#{folder}/#{name}.jade"
      @rm "#{@STYLES_FOLDER}/#{folder}/#{name}.styl"

  controller:( name, args, mvc = false )->
    @rm "#{@APP_FOLDER}/controllers/#{name}.coffee"


  rm:( filepath )->
    relative = filepath.replace @the.app_root + '/', ''

    if fs.existsSync filepath
      try
        if fs.lstatSync( filepath ).isDirectory()
          if @cli.argv.rf
            fsu.rm_rf filepath
          else
            fs.rmDirSync filepath
        else
          fs.unlinkSync filepath
      catch err
        throw new Error err
      if not @repl
        console.log "#{'Removed'.bold} #{relative}".red
    else
      (@repl or console).error "#{'Not found'.bold} #{relative}".yellow