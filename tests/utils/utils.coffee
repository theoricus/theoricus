fs    = require "fs"
os    = require "os"
path  = require 'path'
spawn = (require 'child_process').spawn

#saves a folder as hash
snapshot = exports.snapshot = ( folderpath, buffer = {} )->
  folderpath = path.resolve folderpath

  for file in (files = fs.readdirSync folderpath)

    absolute = path.resolve "#{folderpath}/#{file}"
    relative = absolute.replace folderpath, ''

    try
      if fs.lstatSync( absolute ).isDirectory()
        buffer[ relative ] = 'folder'
        snapshot absolute, buffer
      else
        unless /.gitkeep/.test relative
          buffer[ relative ] = fs.readFileSync( absolute ).toString()
    catch error
      throw error

  buffer

#spawn theoricus on the command line
exports.spawn = (args, options) ->
  theoricus_path = path.join __dirname, '../../bin/theoricus'

  # Win32 urges some MAGIC in order to do basic things such as spawn a node
  # program or any other program that isn't a .exe. Gorgeous.
  if os.platform() is 'win32'
    runner = "cmd"
    args = ['/S', '/C', 'node', theoricus_path].concat args

  # No magic need for *unix systems.
  else
    runner = theoricus_path

  spawn runner, args, options || {cwd: __dirname}