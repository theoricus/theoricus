path = require 'path'
fork = (require 'child_process' ).fork

polvo = require 'polvo'

module.exports = class Compiler

  constructor:( @the, @cli, release, webserver )->
    return unless @the.is_theoricus_app()

    options = base: @the.app_root

    if release?
      options.release = true
    else
      options.compile = true

    options.server = true if webserver?
    polvo options