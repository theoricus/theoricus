module.exports = class Controller
  fs = require 'fs'

  constructor:( @the, name )->
    name_camel = name.camelize()
    name_lc = name.toLowerCase()

    model_name = name.singularize().camelize()
    model_name_lc = model_name.toLowerCase()

    tmpl = "#{@the.root}/cli/src/generators/templates/mvc/controller.coffee"
    filepath = "app/controllers/#{name.toLowerCase()}.coffee"

    contents = (fs.readFileSync tmpl).toString()
    contents = contents.replace /~NAME_CAMEL/g, name_camel
    contents = contents.replace /~NAME_LC/g, name_lc
    contents = contents.replace /~MODEL_CAMEL/g, model_name
    contents = contents.replace /~MODEL_LCASE/g, model_name_lc

    # write controller
    unless fs.existsSync filepath
      fs.writeFileSync filepath, contents
      console.log "#{'Created'.bold} #{filepath}".green
    else
      console.log "#{'Already exists'.red.bold} #{filepath}".green