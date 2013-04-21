module.exports = class Routes

  # all routes
  @routes =

    # main route
    '/main':
      to: "mains/index"
      at: null
      el: "body"

  # default route
  @root: '/main'