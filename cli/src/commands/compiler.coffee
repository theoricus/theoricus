path = require 'path'
fork = (require 'child_process' ).fork

polvo = require 'polvo'

module.exports = class Compiler

  constructor:( @the, @cli, release, webserver )->
    return unless @the.is_theoricus_app()
    polvo compile: true, base: @the.app_root