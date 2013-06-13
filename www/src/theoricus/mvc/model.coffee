ArrayUtil = require 'theoricus/utils/array_util'
Binder = require 'theoricus/mvc/lib/binder'
_ = require 'lodash'

module.exports = class Model extends Binder

  @_config  = urls: {}, keys: {}
  @_records = []

  id   : null
  _keys: null



  ### --------------------------------------------------------------------------
    Configures model
  -------------------------------------------------------------------------- ###
  @configure:( config )->
    # configure urls ending points
    for method in 'create read update delete all find'
      if (url = config.urls[method])?
        _config.urls[method] = url 

    # configure keys and types
    for key, type in config.keys
      _config.keys[key] = type


  ### --------------------------------------------------------------------------
    Constructor
  -------------------------------------------------------------------------- ###

  constructor:( @id, dict )->
    @_keys = {}
    @set dict


  ### --------------------------------------------------------------------------
    Global validate method, will perform simple validations for native types
    as well as run custom validations against the given methods in configuration
  -------------------------------------------------------------------------- ###
  validate = (key, val)->
    checker = _config.keys[key]

    # validate against native types (Number, String, Array, Object, Date)
    if /native code/.test checker
      switch ("#{checker}".match /function\s(\w+)/)[1]
        when 'String' then return (typeof val is 'string')
        when 'Number' then return (typeof val is 'number')
        else return (val instanceof type)

    # validates against the given method
    else
      return checker val


  ### --------------------------------------------------------------------------
    Getter / Setter
  -------------------------------------------------------------------------- ###
  get:(keyumn)->
    return @_keys[keyumn]

  # set 'prop', 'val'
  # set prop: 'val', prop2: 'val2'
  set:(args...)->

    # if a dictionary is given, set all keys individually
    if args.length is 1
      dict = args[0]
      @set key, val for key, val of dict
      return dict

    # otherwise set the given key / val
    key = arg[0]
    val = arg[1]
    if validate key, val
      return @_keys[key] = val
    else
      throw new Error "Invalid type for keyumn '#{key}' = #{val}"


  ### --------------------------------------------------------------------------
    CURD and helpful methods
  -------------------------------------------------------------------------- ###

  @create:(keys, callback)->
    record = new @ _records.length, keys
    _records.push record

    # returns created model if callback isn't specified
    return record unless callback?

    # sends request to server and handles response
    req = @fetch _config.url.create, 'POST', keys
    req.done (data)-> callback record, data, null
    req.error (error)-> callback record, null, error


  @read:(id, callback)->
    return _records[id] unless callback?

    # sends request to server and handles response
    req = @fetch (_config.url.read.replace /(\:\w+)/, id), 'GET'
    req.done (data)-> callback (@create data), data, null
    req.error (error)-> callback record, null, error


  update:(keys, callback)->
    @set keys
    return keys unless callback?

    # sends request to server and handles response
    req = @fetch (_config.url.update.replace /(\:\w+)/, @id), 'PUT'
    req.done (data)-> callback @, data, null
    req.error (error)-> callback @, null, error


  delete:(callback)->
    record = @_records.splice @get 'id', 1
    record.id-- for record, _id in @_records when _id > id
    return true unless callback?

    # sends request to server and handles response
    req = @fetch (_config.url.update.replace /(\:\w+)/, @id), 'DELETE'
    req.done (data)-> callback true, data, null
    req.error (error)-> callback false, null, error


  @all:( callback )->
    # returns local version if callback isn't specified
    return @_records unless callback?

    # sends request to server and handles response
    req = @fetch _config.url.all, 'GET'
    req.done (data)->
      @create keys for keys in ([].concat data)
      callback do @all, data, null
    req.error (error)->
      callback do @all, null, error


  @find:( keys, callback )->
    # returns local version if callback isn't specified
    if not callback?
      return _.find _records, keys

    # sends request to server and handles response
    req = @fetch _config.url.find, 'POST', keys
    req.done (data)->
      @create _keys for _keys in ([].concat data)
      callback (@find keys), data, null
    req.error (error)->
      callback (@find keys), null, error


  save:( callback )->
    @update _keys, callback


  ### --------------------------------------------------------------------------
    Middleware
  -------------------------------------------------------------------------- ###

  @fetch:( url, type, data )->
    req = {url, type, data}
    
    # sets dataType to json if url ends .json
    req.dataType = 'json'  if /\.json$/m.test( url )

    # return request obj to be listened / handled
    return $.ajax req




### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  USAGE DRAFT
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ###

# >>>>> MODEL
# 
# 
# class User extends AppModel
#
#   @config
#
#     urls:
#       'create' : '/users.json'
#       'read'   : '/users/:id.json'
#       'update' : '/users/:id.json'
#       'delete' : '/users/:id.json'
#       'all'    : '/users.json'
#       'find'   : '/users/find.json'
#
#     keys:
#       'name' : String
#       'age'  : (val)-> return val >= 18 # validates if user is of age
# 
# 
# >>>>> CONTROLLER
# 
# 
# User = require 'app/models/user'
# 
# class Users extends AppController
# 
#   # CREATE
#   record = User.create name: 'anderson', age: 29
#   User.create name: 'anderson', age:29, (record, status, res)->
#     console.log '-----------------------------------'
#     console.log 'record created locally and remotely'
#     console.log 'record', record
#     console.log 'res', res
#     console.log 'error', error
# 
#   # READ
#   record = User.read 0
#   User.read 0, (record, res, error)->
#     console.log '-----------------------------------'
#     console.log 'record read remotely'
#     console.log 'record', record
#     console.log 'res', res
#     console.log 'error', error
# 
#   # UPDATE
#   record.update name: 'arboleya', age: 30
#   record.update name: 'arboleya', age: 30, (record, res, error)->
#     console.log '-----------------------------------'
#     console.log 'record updated locally and remotely'
#     console.log 'record', record
#     console.log 'res', res
#     console.log 'error', error
# 
#   # DELETE
#   do record.delete
#   record.delete (res, error)->
#     console.log '-----------------------------------'
#     console.log 'record deleted locally and remotely'
#     console.log 'res', res
#     console.log 'error', error
# 
#   # ALL
#   records = do User.all
#   User.all (records, res, error)->
#     console.log '-----------------------------------'
#     console.log 'records fetched remotely and saved locally, returning all'
#     console.log 'records', records
#     console.log 'res', res
#     console.log 'error', error
# 
#   # FIND
#   records = do User.find name: 'anderson'
#   User.find (records, res, error)->
#     console.log '-----------------------------------'
#     console.log 'records fetched remotely and saved locally, finding in both'
#     console.log 'records', records
#     console.log 'res', res
#     console.log 'error', error