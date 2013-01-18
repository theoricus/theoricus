#<< theoricus/utils/object_util

class theoricus.utils.ArrayUtil
  {ObjectUtil} = theoricus.utils
  
  ###
  @param [] src
  @param [] search
  ###
  @find:( src, search )->
    for v, i in src
      unless (search instanceof Object)
        return item: v, index:i if v == search
      else
        return {item: v, index:i } if ObjectUtil.find(v, search)?
    return null

  ###
  @param [] src
  @param [] search
  ###
  @delete:( src, search )->
    item = ArrayUtil.find src, search
    src.splice item.index, 1 if item?