class MainView extends app.views.AppView
	# render:( data )->
	# 	@render_template "main", data

	set_triggers:()->
		console.log "ah garoto..."
		@el.find( "a" ).click ( ev )=>
			console.log "CLICKED!"
			ev.preventDefault()
			@navigate $( ev.target ).attr( "href" )