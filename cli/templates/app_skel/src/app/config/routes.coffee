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

  # default route
  @root = '/pages/index'