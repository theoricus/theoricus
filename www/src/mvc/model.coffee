#>> theoricus/utils/array_util

class theoricus.mvc.ModelBinder

	# filter regex to catch all binds injected by theoricus
	context_reg = '(<!-- @[\\w]+ -->)([^<]+)(<!-- \/@[\\w]+ -->)'
	bind_reg = "(<!-- @~KEY -->)([^<]+)(<!-- \/@~KEY -->)"
	bind_name_reg = /(<!-- @)([\w]+)( -->)/
	binds: null

	constructor:->
		@binds = {}

	bind:( dom )->
		@binds = (parse dom)

	update_binding_for:( field, val )->

		return if @binds[field] is null

		for item in (@binds[field] || [])
			
			node = ($ item.target)
			switch item.type
				when 'node'
					current = node.html()
					search = new RegExp (bind_reg.replace /\~KEY/g, field), 'g'
					updated = current.replace search, "$1#{val}$3"
					node.html updated
					break

				when 'attr'
					node.attr item.attr, val

	parse = (dom, binds = {})->
		dom.children().each ->
			# searching for binds in node attributes
			for attr in this.attributes
				name = attr.nodeName
				value = attr.nodeValue

				# get attribute's binds
				match_single = new RegExp context_reg
				if match_single.test value
					key = (value.match bind_name_reg)[2]
					(($ this).attr name, (value.match match_single)[2])
					collect binds, this, 'attr', key, name

			# preparing node to start the search for binds
			match_all = new RegExp context_reg, 'g'
			text = ($ this ).clone().children().remove().end().html()
			text = "#{text}"

			# get all binds (multiple binds per node is allowed)
			keys = (text.match match_all) or []

			# collects all found binds for the node value
			for key in keys
				key = (key.match bind_name_reg)[2]
				collect binds, this, 'node', key

			

			# keep parsing the dom recursively
			parse ($ this), binds

		binds

	collect = (binds, target, type, variable, attr)->
		bind = (binds[variable] ?= [])
		tmp = type: type, target: target
		tmp.attr = attr if attr?
		bind.push tmp

class theoricus.mvc.Model extends theoricus.mvc.ModelBinder
	{ArrayUtil} = theoricus.utils

	_fields = []
	_collection = []

	# SETUP METHODS ############################################################

	@rest=( host, resources )->
		[resources, host] = [host, null] unless resources?
		for k, v of resources
			@[k] = @_build_rest.apply @, [k].concat(v.concat host)

	@fields=( fields )->
		@_build_gs key, type for key, type of fields



	# SETUP HELPERS ############################################################

	###
	Build a static rest call for the given params

	@param [String] key 	
	@param [String] method 	
	@param [String] url 	
	@param [String] domain 	
	###
	@_build_rest=( key, method, url, domain )->
		( args... )->
			if key is "read" and _collection.length
				found = ArrayUtil.find _collection, {id: args[0]}
				return found.item if found?
			
			if args.length
				if (typeof args[args.length-1] is 'object')
					data = args.pop()
				else
					data = ''

			while (/:\w+/.exec url)?
				url = url.replace /:\w+/, args.shift() || null

			url = "#{domain}/#{url}".replace /\/\//g, '/' if domain?
			@_request method, url, data

	###
	Builds local getters/setters for the given params

	@param [String] field
	@param [String] type
	###
	@_build_gs=( field, type )->
		_val = null

		classname = ("#{@}".match /function\s(\w+)/)[1]
		stype = ("#{type}".match /function\s(\w+)/)[1]
		ltype = stype.toLowerCase()

		getter=-> _val
		setter=(value)->

			switch ltype
				when 'string' then f = (typeof value is 'string')
				when 'number' then f = (typeof value is 'number')
				else f = (value instanceof type)

			if f
				_val = value
				@update_binding_for field, _val
			else
				prop = "#{classname}.#{field}"
				msg = "Property '#{prop}' must to be #{stype}."
				throw new Error msg

		@::.__defineGetter__ field, getter
		@::.__defineSetter__ field, setter



	###
	General request method

	@param [String] method 	URL request method
	@param [String] url 	URL to be requested
	@param [Object] data 	Data to be send
	###
	@_request=( method, url, data='' )->
		fetcher = new theoricus.mvc.Fetcher

		req = $.ajax url:url, type: method, data: data

		req.done ( data )=>
			fetcher.loaded = true
			fetcher.records = @_instantiate data
			fetcher.onload?( fetcher.records )

		req.error ( error )=>
			fetcher.error = true
			if fetcher.onerror?
				fetcher.onerror error
			else
				throw error

		fetcher



	###
	Instantiate new Model instances passing items as initial data

	@param [Object] data	Data to be parsed
	###
	@_instantiate=( data )->
		Factory = theoricus.core.Factory
		classname = ("#{@}".match /function\s(\w+)/)[1]
		records = []
		for record in [].concat data
			model = (Factory.model classname, record)
			records.push model

		_collection = _collection.concat records

		return if records.length is 1 then records[0] else records



# SIMPLE FETCHER CLASS #########################################################
class theoricus.mvc.Fetcher
	loaded: null

	onload: null
	onerror: null

	data: null