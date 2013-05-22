path = require 'path'

module.exports = class Model
  fs = require 'fs'

  constructor:( @the, name )->
    name_camel = name.camelize()
    name_lc = name.toLowerCase()
    controller_name_lc = name.pluralize().toLowerCase()

    tmpl = path.join @the.root, 'cli', 'templates', 'mvc', 'model.coffee'

    models = path.join @the.app_root, 'src', 'app', 'models'
    filepath = path.join models, "#{name.toLowerCase()}.coffee"

    contents = (fs.readFileSync tmpl).toString()
    contents = contents.replace /~NAME_CAMEL/g, name_camel
    contents = contents.replace /~CONTROLLER_LC/g, controller_name_lc

    # write model
    unless fs.existsSync filepath
      fs.writeFileSync filepath, contents
      console.log "#{'Created'.bold} #{filepath}".green
    else
      console.log "#{'Already exists'.red.bold} #{filepath}".green