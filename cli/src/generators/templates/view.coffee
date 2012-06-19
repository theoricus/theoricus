# app ?= {}
# app.controllers: AppView:()->

# class VIEW_NAME extends app.controllers.AppView

	## uncomment to override
	# 
	# in:( after_in )->
	# 	if !@the.boot.enable_auto_transitions || @the.boot.disable_transitions
	# 		after_in?()
	# 	else
	# 		@el.css "opacity", 0
	# 		@el.animate {opacity: 1}, 600, =>
	# 			after_in?()
	# 
	# out:( after_out )->
	# 	if @the.boot.disable_transitions
	# 		after_out?()
	# 	else
	# 		@el.animate {opacity: 0}, 300, after_out