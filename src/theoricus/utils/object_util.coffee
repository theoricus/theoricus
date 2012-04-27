class ObjectUtil
	@find:( src, search )->
		for k, v of search
			if v instanceof Object
				return ObjectUtil.find src[k], v
			else
				return src if src[k] == v
		return null