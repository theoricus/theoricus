AppView = require 'app/views/app_view'
Style = require 'styles/routing/deep'

initialized = false

module.exports = class Deep extends AppView

  after_render:->
    super
    return if initialized
    initialized = true
    ($ '#deep-param').data 'initial', true
    console.log 'yeah'
