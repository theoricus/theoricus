fsu = require 'fs-util'
polvo = require './polvo'
selenium = require './selenium'

polvo.start ->
  do selenium.start

process.on 'exit', ->
  do polvo.stop
  do selenium.stop