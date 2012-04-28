class MainView extends app.views.AppView
	# render:( data )->
	# 	@render_template "main", data

	set_triggers:()->
		@el.find( "a" ).click ( ev )=>
			console.log "I WAS CLICKED!"
			ev.preventDefault()
			@navigate $( ev.target ).attr "href"