class StringUtil
	@ucfirst=( str )->
		a = str.substr( 0, 1 ).toUpperCase()
		b = str.substr( 1 ).toLowerCase()
		return a + b

	@camelize=( str )->
		parts = [].concat( str.split "_" )
		buffer = ""
		buffer += StringUtil.ucfirst part for part in parts

	@underscore=( str )->
		str = str.replace( /([A-Z])/g, "_$1" ).toLowerCase()
		str = if str.substr( 1 ) == "_" then str.substr 1 else str