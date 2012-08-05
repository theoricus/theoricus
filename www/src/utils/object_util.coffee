class theoricus.utils.ObjectUtil
	@find:( src, search )->
		for k, v of search
			return ObjectUtil.find src[k], v if v instanceof Object
			return src if src[k] == v
		return null