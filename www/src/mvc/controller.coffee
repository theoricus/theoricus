#<< theoricus/utils/string_util

class theoricus.mvc.Controller
	Factory = null
	{StringUtil} = theoricus.utils

	_boot:( @the )->
		Factory = @the.factory
		@

	_build_action:( process )->
		=>
			api = process.route.api
			[ctrl, action] = [api.controller_name, api.action_name]
			@view( "#{ctrl}/#{action}", process ).render (@model ctrl)

	view:( path )->
		v = Factory.view path
		v.process = @process
		v

	model:( name, init )->
		m = Factory.model name, init
		# m.process = @process # currently useless, so commented
		m