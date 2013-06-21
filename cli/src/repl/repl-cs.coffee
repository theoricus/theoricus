vm = require 'vm'
cs = require 'coffee-script'
cs_nodes = require 'coffee-script/lib/coffee-script/nodes'

{merge, prettyErrorMessage} = require 'coffee-script/lib/coffee-script/helpers'

# CODE BORROWED FROM 
# https://github.com/jashkenas/coffee-script/blob/master/src/repl.coffee
module.exports = (input, context, filename, cb) ->

  # XXX: multiline hack.
  input = input.replace /\uFF00/g, '\n'

  # Node's REPL sends the input ending with a newline and then wrapped in
  # parens. Unwrap all that.
  input = input.replace /^\(([\s\S]*)\n\)$/m, '$1'

  # Require AST nodes to do some AST manipulation.
  {Block, Assign, Value, Literal} = cs_nodes

  try
    # Generate the AST of the clean input.
    ast = cs.nodes input

    # Add assignment to `_` variable to force the input to be an expression.
    ast = new Block [
      new Assign (new Value new Literal '_'), ast, '='
    ]

    js = ast.compile bare: yes, locals: Object.keys(context)
    cb null, vm.runInContext(js, context, filename)

  catch err
    cb prettyErrorMessage(err, filename, input, yes)