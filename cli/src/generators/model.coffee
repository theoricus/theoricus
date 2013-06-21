path = require 'path'

module.exports = class Model
  fs = require 'fs'

  constructor:( @the, name, @repl )->
    name_camel = name.camelize()
    name_lc = name.toLowerCase()
    controller_name_lc = name.pluralize().toLowerCase()

    tmpl = path.join @the.root, 'cli', 'templates', 'mvc', 'model.coffee'

    models = path.join @the.app_root, 'src', 'app', 'models'
    filepath = path.join models, "#{name.toLowerCase()}.coffee"
    relative = filepath.replace @the.app_root + '/', ''

    contents = (fs.readFileSync tmpl).toString()
    contents = contents.replace /~NAME_CAMEL/g, name_camel
    contents = contents.replace /~CONTROLLER_LC/g, controller_name_lc

    # write model
    unless fs.existsSync filepath
      fs.writeFileSync filepath, contents
      if not @repl
        console.log "#{'Created'.bold} #{relative}".green
    else
      (@repl or console).error "#{'Already exists'.bold} #{relative}".yellow