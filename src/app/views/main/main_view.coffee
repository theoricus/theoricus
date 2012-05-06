class MainView extends app.views.AppView
	# render:( data )->
	# 	@render_template "main", data, true

	set_triggers:()->
		@el.find( "a" ).click ( ev )=>
			# console.log "I WAS CLICKED!"
			@navigate $( ev.target ).attr "href"
			ev.preventDefault() unless @the.boot.no_push_state