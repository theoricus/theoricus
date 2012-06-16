class AddProject
	
	path = require 'path'
	pn = path.normalize
	exec = (require "child_process").exec

	constructor:( @the, @options )->
		@pwd = @the.pwd
		@root = @the.root

		@app_skel = pn "#{@root}/cli/theoricus/generators/templates/app_skel"
		@target = pn "#{@pwd}/#{@options[1]}"

		if path.existsSync @target
			console.log "ERROR: Target directory already existis. Do you " +
						"wanna overwrite it? You'll lose everything."
			return # if no

		cmd = "cp -r #{@app_skel} #{@target}"
		exec cmd, (error, stdout, stderr)=>
			if error?
				console.log error 
			else
				exec "find #{@target}", (error, stdout, stderr)=>
					files = stdout.split("\n").slice 0, -1
					for file in files
						console.log "#{'Created'.bold} #{file}".green