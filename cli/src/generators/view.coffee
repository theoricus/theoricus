fs = require 'fs'
fsu = require 'fs-util'
path = require 'path'

module.exports = class View

  constructor:( @the, name, controller_name_lc, mvc = false, @cli )->
  
    # TODO add option to pass the engine for javascript, styles and jade
    # by now it's hardcoded for coffeescript, stylus and jade

    # shell = @cli.join ' '
    
    # templates_ext = shell.match /--templates[\s]*([^\s]+)/
    # templates_ext = if templates_ext? then templates_ext[1] else 'jade'

    # styles_ext = shell.match /--styles[\s]*([^\s]+)/
    # styles_ext = if styles_ext? then styles_ext[1] else 'styl'

    name_camel = name.camelize()
    name_lc    = name.toLowerCase()

    src = path.join @the.app_root, 'src'
    view_folder = path.join src, "app/views/#{controller_name_lc}"
    template_folder = path.join src, "templates/#{controller_name_lc}"
    style_folder = path.join src, "styles/#{controller_name_lc}"

    if mvc
      view_path = "#{view_folder}/index.coffee"
      template_path = "#{template_folder}/index.jade"
      style_path = "#{style_folder}/index.styl"
    else
      view_path = "#{view_folder}/#{name_lc}.coffee"
      template_path = "#{template_folder}/#{name_lc}.jade"
      style_path = "#{style_folder}/#{name_lc}.styl"

    # prepare contents
    tmpl_mvc = "#{@the.root}/cli/templates/mvc"

    tmpl_view = "#{tmpl_mvc}/view.coffee"
    tmpl_template = "#{tmpl_mvc}/view.jade"
    tmpl_style = "#{tmpl_mvc}/view.styl"

    # create folder containers
    try
      fsu.mkdir_p view_folder 
      fsu.mkdir_p template_folder
      fsu.mkdir_p style_folder
    catch e
      # folder already exists
      # just add the files

    # prepare view contents
    contents = (fs.readFileSync tmpl_view).toString()
    contents = contents.replace /~NAME_LOWER/g, name_lc
    contents = contents.replace /~NAME_CAMEL/g, name_camel
    contents = contents.replace /~CONTROLLER_NAME_LC/g, controller_name_lc

    # write view
    fs.writeFileSync view_path, contents
    console.log "#{'Created'.bold} #{view_path}".green

    # write jade
    unless fs.existsSync template_path
      fs.writeFileSync template_path, (fs.readFileSync tmpl_template)
      console.log "#{'Created'.bold} #{template_path}".green
    else
      console.log "#{'Already exists'.bold} #{template_path}".green

    # write stylus
    unless fs.existsSync style_path
      fs.writeFileSync style_path, fs.readFileSync tmpl_style
      console.log "#{'Created'.bold} #{style_path}".green
    else
      console.log "#{'Already exists'.bold} #{style_path}".green
