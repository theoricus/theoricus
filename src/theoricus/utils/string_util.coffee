class StringUtil
	@ucfirst:( str )->
		a = str.substr( 0, 1).toUpperCase()
		b = str.substr( 1 ).toLowerCase()
		return a + b