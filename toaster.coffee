# a single build's config
#  ~> many can be specified repeating everything bellow this line
toast

  name: 'theoricus'

  # src folders (relative to this!)
  dirs:[
    'www/src'
  ]

  # main module
  main: 'theoricus/theoricus'

  # release folder
  release_dir: 'lib/js'

  # excluded items (default=[])
  exclude: []

  # removes coffee safety wrapper (default=true - duplicates the AMD wrapper)
  bare: true

  # minifies release files (default=true)
  minify: false

  # infos for simple static server (with -s option)
  webroot: 'lib'
  port: 3000

  # optimization configs (when specified, means toaster's loader will be used)
  # the resulting will probably not be usefull with another AMD loader
  optimize:

    # base url to reach your release folder through http
    base_url: 'js'

    # vendors to consider (can be local or remote)
    vendors:
      'history': 'www/vendors/history.js/scripts/bundled/html4+html5/native.history.js'
      'jade': 'www/vendors/jade/runtime.js'
      'inflection': 'www/vendors/inflection.js'
      'jquery': 'www/vendors/jquery.js'
      'json': 'www/vendors/JSON-js/json2.js'

    # each layer wil hold all the definitions needed (all levels) in order to
    # work. if layers share dpendencies, they will not repeat acros layers.
    # layers:
    #   'main': ['app/app']
    #   'users': ['app/controllers/users']