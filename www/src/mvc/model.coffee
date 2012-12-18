#>> theoricus/utils/array_util

class theoricus.mvc.Model
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
				# @_on_update()
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