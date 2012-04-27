#<< theoricus/utils/object_util

class ArrayUtil
	ObjectUtil = theoricus.utils.ObjectUtil

	@find:( src, search )->
		for v, i in src
			if search instanceof String
				if v == src
					return {item: v, index:i}
			else if search instanceof Object
				if ObjectUtil.find(v, search)?
					return {item: v, index:i}
		return null

	@delete:( src, search )->
		item = ArrayUtil.find src, search
		src.splice item.index, 1 if item?