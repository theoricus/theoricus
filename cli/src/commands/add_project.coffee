fs   = require 'fs'
path = require 'path'
pn   = path.normalize
exec = (require "child_process").exec

module.exports = class AddProject

  constructor:( @the, @options )->
    if not options[1]?
      console.log "ERROR".bold.red + " You must specify a name for your project"
      return

    @pwd = @the.pwd
    @root = @the.root

    @app_skel = path.join @the.root, 'cli', 'templates', 'app_skel'
    @target   = path.join @pwd, @options[1]

    if fs.existsSync @target

      console.log "ERROR".bold.red + " Target directory already existis."
      console.log "\n\t"
      console.log "#{@target}".yellow
            
      return

    cmd = "cp -r #{@app_skel} #{@target}"
    exec cmd, (error, stdout, stderr)=>
      if error?
        console.log error 
      else
        exec "find #{@target}", (error, stdout, stderr)=>
          files = stdout.split("\n").slice 0, -1
          for file in files
            console.log "#{'Created'.bold} #{file}".green
