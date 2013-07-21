AppView = require 'app/views/app_view'
Style = require 'styles/routing/deep'

module.exports = class Deep extends AppView

  after_render:->
    pathname = window.location.pathname
    return if pathname is '/routing/dynamic/theoricus'
    ($ '#deep-param').data 'initial', true

  before_destroy:->
    ($ '#deep-param').data 'initial', false