path = require 'path'

module.exports = class Controller
  fs = require 'fs'

  constructor:( @the, name, @repl )->
    name_camel = name.camelize()
    name_lc = name.toLowerCase()

    model_name = name.singularize().camelize()
    model_name_lc = model_name.toLowerCase()

    tmpl = path.join @the.root, 'cli', 'templates', 'mvc'
    tmpl = path.join tmpl, 'controller.coffee'

    controllers = path.join @the.app_root, 'src', 'app', 'controllers'
    filepath = path.join controllers, "#{name.toLowerCase()}.coffee"
    relative = filepath.replace @the.app_root + '/', ''

    contents = (fs.readFileSync tmpl).toString()
    contents = contents.replace /~NAME_CAMEL/g, name_camel
    contents = contents.replace /~NAME_LC/g, name_lc
    contents = contents.replace /~MODEL_CAMEL/g, model_name
    contents = contents.replace /~MODEL_LCASE/g, model_name_lc

    # write controller
    unless fs.existsSync filepath
      fs.writeFileSync filepath, contents
      if not @repl
        console.log "#{'Created'.bold} #{relative}".green
    else
      (@repl or console).error "#{'Already exists'.bold} #{relative}".yellow