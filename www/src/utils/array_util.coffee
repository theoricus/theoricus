#<< theoricus/utils/object_util

class theoricus.utils.ArrayUtil
	{ObjectUtil} = theoricus.utils
	
	@find:( src, search )->
		for v, i in src
			if search instanceof String
				return item: v, index:i if v == search
			else if search instanceof Object
				return {item: v, index:i } if ObjectUtil.find(v, search)?
		return null

	@delete:( src, search )->
		item = ArrayUtil.find src, search
		src.splice item.index, 1 if item?