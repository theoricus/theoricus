class MainView extends app.views.AppView
	
	# if you haven't defined the render method, the code
	# bellow is processed automatically
	# 
	# render:( data )->
	#	# @usage: @render_template template_name, data
	# 	@render_template "main", data

	in:()->
		$( @route.at ).css( "opacity", 0 )
		$( @route.at ).animate({opacity:1}, {duration:1000})
	
	out:()->
		$( @route.at ).animate({opacity:0}, {duration:1000})