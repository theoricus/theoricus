class theoricus.utils.StringUtil

	###
	@param [String] str
	###
	@ucfirst=( str )->
		a = str.substr( 0, 1 ).toUpperCase()
		b = str.substr( 1 ).toLowerCase()
		return a + b

	###
	@param [String] str
	###
	@camelize=( str )->
		parts = [].concat( str.split "_" )
		buffer = ""
		buffer += StringUtil.ucfirst part for part in parts

	###
	@param [String] str
	###
	@underscore=( str )->
		str = str.replace( /([A-Z])/g, "_$1" ).toLowerCase()
		str = if str.substr( 1 ) == "_" then str.substr 1 else str