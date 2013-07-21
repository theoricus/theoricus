AppView = require 'app/views/app_view'
Style = require 'styles/routing/deep'

initialized = false

module.exports = class Deep extends AppView

  after_render:->
    return if initialized
    initialized = true
    ($ '#deep-param').data 'initial', true

  before_destroy:->
    ($ '#deep-param').data 'initial', false