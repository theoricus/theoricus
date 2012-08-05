class theoricus.commands.Add
	constructor:( @the, opts )->

		action = opts[1]
		switch action
			when "model"
				new theoricus.generators.Model @the, opts
			when "view"
				new theoricus.generators.View @the, opts
			when "controller"
				new theoricus.generators.Controller @the, opts
			when "mvc"
				new theoricus.generators.Model @the, opts
				new theoricus.generators.Controller @the, opts
				new theoricus.generators.View @the, opts
			else
				console.log "ERROR: Valid options: controller,model,view,mvc."