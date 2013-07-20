module.exports = class Routes

  # all routes
  @routes =

    # main route
    '/pages':
      to: "pages/container"
      at: null
      el: "body"
    
    '/pages/index':
      to: "pages/index"
      at: "/pages"
      el: "#container"



    '/routing/simple':
      to: "routing/simple"
      at: "/pages"
      el: "#container"

    '/routing/deep/?(:name)?':
      to: "routing/deep"
      at: "/routing/simple"
      el: "#simple-container"

    '/routing/dynamic':
      to: "routing/dynamic"
      at: "/routing/deep"
      el: "#deep-container"

    '/routing/dynamic/:name':
      to: "routing/dynamic"
      at: "/routing/deep/:name"
      el: "#deep-container"



    '/title/theoricus':
      to: "title/theoricus"
      at: "/pages"
      el: "#container"

    '/title/is':
      to: "title/is"
      at: "/pages"
      el: "#container"

    '/title/awesome':
      to: "title/awesome"
      at: "/pages"
      el: "#container"



    '/404':
      to: "pages/notfound"
      at: "/pages"
      el: "#container"

  # default route
  @root = '/pages/index'

  # not found route
  @notfound = '/404'