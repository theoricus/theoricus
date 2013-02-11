fs = require "fs"
path = require "path"
colors = require 'colors'

require '../vendors/inflection'

Add = require './commands/add'
AddProject = require './commands/add_project'
Rm = require './commands/rm'
Server = require './commands/server'
StaticServer = require './commands/static_server'
Compiler = require './commands/compiler'
Index = require './commands/index'

exports.run = ->
  new Theoricus

module.exports = class Theoricus
  
  constructor:->
    @root = path.join __dirname, "../.."
    @app_root = @_get_app_root()
    @pwd = @app_root || path.resolve "."

    @version = (require "#{@root}/package.json" ).version
    cmds =  "#{'model'.cyan}#{'|'.white}#{'view'.cyan}#{'|'.white}" +
        "#{'controller'.cyan}#{'|'.white}#{'mvc'.cyan}"

    @header = "#{'Theoricus'.bold} " + "v#{@version}\nCoffeeScript MVC implementation for the browser + lazy navigation mechanism.\n\n".grey

    @header += "#{'Usage:'.bold}\n"
    @header += "  theoricus #{'new'.red}      #{'path'.green}\n"
    @header += "  theoricus #{'add'.red}      #{cmds} \n" #[#{'name'.magenta}] [#{'field1'.yellow}] [#{'field2'.yellow}]\n"
    @header += "  theoricus #{'rm'.red}       #{cmds} \n" #[#{'name'.magenta}]\n"
    @header += "  theoricus #{'start'.red}    #{'port'.green} default is #{'11235'.yellow}\n"
    @header += "  theoricus #{'compile'.red}  #{'port'.green} default is #{'http://localhost:11235'.yellow}\n"
    @header += "  theoricus #{'index'.red}    \n\n"
    
    @header += "#{'Options:'.bold}\n"
    @header += "             #{'new'.red}   Creates a new working project in the file system.\n"
    @header += "             #{'add'.red}   Generates a new model|view|controller file.\n"
    @header += "              #{'rm'.red}   Destroy some model|view|controller file.\n"
    @header += "           #{'start'.red}   Starts app in watch'n'compile mode at http://localhost:11235\n"
    @header += "         #{'compile'.red}   Compile app to release destination.\n"
    @header += "           #{'index'.red}   Index the whole application to a static non-js version.\n"
    @header += "         #{'version'.red}   Show theoricus version.\n"
    @header += "            #{'help'.red}   Show this help screen.\n"

    options = process.argv.slice 2
    cmd = options.join( " " ).match /([a-z]+)/
    cmd = if cmd? then cmd[1] else 'help'
    

    if @app_root == null and cmd != "help" and cmd != "new"
      console.log "ERROR".bold.red + " Not a Theoricus app."
      return

    options.watch ?= false

    switch cmd
      when "new"     then new AddProject @, options
      when "add"     then new Add @, options
      when "rm"      then new Rm @, options
      when "start"   then new Server @, options
      when "static"  then new StaticServer @, options
      when "compile" then new Compiler @, options
      when "index"   then new Index @, options
      when "version"
        console.log @version
      else
        console.log @header

  _get_app_root:()->
    current = path.resolve "."

    while true
      app = path.normalize "#{current}/src/app/app.coffee"

      if fs.existsSync app
        contents = fs.readFileSync app, "utf-8"
        if contents.indexOf( 'extends Theoricus' ) > 0
          return current
        else
          return null
      else
        tmp = path.normalize (path.join current, '..')
        if current == tmp
          return null
        else
          current = tmp
          continue