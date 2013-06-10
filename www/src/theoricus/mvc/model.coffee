ArrayUtil = require 'theoricus/utils/array_util'
Binder = require 'theoricus/mvc/lib/binder'
Factory = require 'theoricus/core/factory'

module.exports = class Model extends Binder

  # Instance properties

  rest:
    "all":""
    "create":""
    "update":""
    "delete":""

  fields:null

  # Class properties

  @_records:[]

  @fetcher:null

  # Class methods

  @fetch:(callback)->
    @fetcher.fetch 
  
  @all:()->
    return @_records
  
  @create:(attrs)->
    model = new @
    model[prop] = attrs[prop] for prop of attrs
    model.uid = @_guid()
    model.id = @_records.length
    @_records.push model
  
  @delete:(id)->
    for model, index in @_records
      if model.id === id or model.guid === id
        record_index = index

    @_records.splice record_index, 1
  
  @read:(attr)->
    ArrayUtil.find @_records, attr

  @save:->
    @fetcher.update @_records

  @_guid:->
    "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
      r = Math.random() * 16 | 0
      v = (if c is "x" then r else (r & 0x3 | 0x8))
      v.toString 16

  # Instance methods

  remove:->

  save:->

  constructor:->