util = require 'util'
repl = require 'repl'
fs = require 'fs'

colors = require 'colors'
path = require 'path'

cs = require 'coffee-script'
cs_eval = require './repl-cs'

Event = require '../utils/event'

module.exports = class REPL extends Event
  mode: 'cs'
  initialized: false

  constructor:->
    console.log '➜  ' + 'initializing..'.grey
    {@stdout, @stdin} = process



  start:->
    msg = ['   Run'.grey, '.help'.white.bold, 'to see options'.grey].join ' '
    console.log msg

    useColors = true
    terminal = true
    prompt = do @format_prompt

    @repl = repl.start {prompt, @eval, useColors, terminal}
    @repl.rli.setPrompt prompt, prompt.stripColors.length
    @repl.rli.prompt true

    do @configure_repl
    do @wrap_repl_interactions
    do @wrap_rli_interactions

    @initialized = true



  configure_repl:->

    standard_cmds = '.break .clear .exit .help .save .load'.split ' '
    max_length = 0
    polyfills = ' '

    @repl.commands['.help'] = help: 'Show repl options', action: =>
      @help standard_cmds, max_length, polyfills

    @repl.commands['.set_mode'] =
      help: 'Switches eval mode between javascript and coffeescript [js|cs]'
      action: @set_mode

    @repl.commands['.g'] =
      help: 'Generates models, views and controllers:'.white +
      """\n\t\t.g model <model-name>
        \t\t.g view <controller-name>/<view-name>
        \t\t.g controller <controller-name>
        \t\t.g mvc <controller-name>
        \t\t#{'  * models,views=singular, controllers=plural'.cyan}
      """.grey
      action: @generate

    @repl.commands['.d'] =
      help: 'Destroys models, views and controllers:'.white +
      """\n\t\t.d model <model-name>
        \t\t.d view <controller-name>/<view-name>
        \t\t.d controller <controller-name>
        \t\t.d mvc <controller-name>
        \t\t.d mvc <controller-name> --rf (delete the whole view folder)
        \t\t#{'  * models,views=singular, controllers=plural'.cyan}
      """.grey
      action: @destroy

    for name, cmd of @repl.commands
      max_length = Math.max max_length, name.length
      polyfills = (Array max_length).join ' '



  # REPL commands
  help:( standard_cmds, max_length, polyfills )->
    @log '» '.bold.magenta + 'default'.bold.magenta
    for name, cmd of @repl.commands when name in standard_cmds
      framed = (polyfills + name).slice -max_length
      @log "#{framed}  #{cmd.help}"

    @log '\n   ' + '» '.bold.magenta + 'theoricus'.bold.magenta
    for name, cmd of @repl.commands when name not in standard_cmds
      framed = (polyfills + name).slice -max_length
      @log "#{framed}  #{cmd.help}"


  set_mode:( mode )=>
    @[mode] = mode
    do @refresh_promt
    @log 'Mode switched to:'.grey, mode.green


  generate:( input )=>
    [type, name] = input.trim().split ' '

    if not type
      return @error 'Type not informed (model, view, controller, mvc) »'.red,
                  '.g [type] [name]'.white

    if not name
      return @error 'Name not informed »'.red,
                  '.g [type] [name]'.white

    @emit 'generate', type, name


  destroy:( input )=>
    [type, name, rf] = input.trim().split ' '

    if not type (/^--/.test type)
      return @error 'Type not informed (model, view, controller, mvc) »'.red,
                  '.d [type] [name] [--rf]'.white

    if not name or (/^--/.test name)
      return @error 'Name not informed »'.red,
                  '.d [type] [name] [--rf]'.white

    @emit 'destroy', type, name, rf is '--rf'



  # REPL & RLI wrappers
  wrap_repl_interactions:->
    @repl.on 'exit', =>
      @emit 'close'
      do process.exit

  wrap_rli_interactions:->
    quit = 0

    # lines commented will be useful for a future multiline input implementation
    # like the coffee repl does:
    #   -> https://github.com/jashkenas/coffee-script/blob/master/src/repl.coffee#L43-L53
    # 
    # on_line = (@repl.rli.listeners 'line')[0]
    # @repl.rli.removeListener 'line', on_line
    @repl.rli.on 'line', (cmd) =>
      # on_line cmd
      quit = 0
      prompt = do @format_prompt
      @repl.rli.setPrompt prompt, prompt.stripColors.length
      @repl.rli.prompt true

    on_sigint = (@repl.rli.listeners 'SIGINT')[0]
    @repl.rli.removeListener 'SIGINT', on_sigint
    @repl.rli.on 'SIGINT', =>
      return do @repl.rli.close if ++quit is 2

      console.log  '\r\n(^C again to quit)'
      prompt = do @format_prompt
      @repl.rli.setPrompt prompt, prompt.stripColors.length
      @repl.rli.prompt true



  # repl custom eval
  eval:(input, context, filename, callback)=>
    # decides which mode to run on
    switch @mode
      when 'cs'
        cs_eval.apply null, arguments
        do @refresh_promt
      when 'js'
        try
          callback null, (eval input)
        catch err
          callback err
        do @refresh_promt



  # prompt manipulations
  format_prompt:->
    start = '➜ '.red
    the = 'theoricus'.bold.grey
    mode = "(#{@mode})".cyan
    # arrow = '⌘  '.red
    return "#{start} #{the}:#{mode} "

  refresh_promt:->
    prompt = do @format_prompt
    @repl.rli.setPrompt prompt, prompt.stripColors.length
    @repl.rli.prompt true

  clear_prompt:->
    chars = (do @format_prompt).length + 1
    @stdout.write "\x1B[#{chars}D"
    @stdout.write Array(chars).join ' '
    @stdout.write "\x1B[#{chars}D"

  show_prompt:->  
    @stdout.write do @format_prompt

  # console.log / console.error middlewares
  log:( msg... )->
    do @clear_prompt if @initialized
    console.log.apply null, ['  '].concat msg
    do @show_prompt  if @initialized

  error:( msg... )->
    do @clear_prompt if @initialized
    console.error.apply null, ['  '].concat msg
    do @show_prompt if @initialized