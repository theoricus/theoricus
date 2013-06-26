# Theoricus #

Tiny MV(C) implementation for client side projects.

> Version 0.2.16

[![Dependency Status](https://gemnasium.com/serpentem/theoricus.png)](https://gemnasium.com/serpentem/theoricus)

# About

Theoricus uses simple naming conventions (as you see in rails and many others),
with a powerful build system behind it. There's also a naviagation mechanism
built to let your free to code your shit instead of handling url's manually.

Theoricus uses some lovely pre-processed languages to accomplish the goals:

 - [Stylus](https://github.com/learnboost/stylus) (css)
 - [Jade](https://github.com/visionmedia/jade) (html)
 - [CoffeeScript](https://github.com/jashkenas/coffee-script) (js)

> More languages will be available in the future, following
[Polvo](http://github.com/serpentem/polvo) capabilities.

It's in a very alpha version, use at your own risk.

Have fun. :)

# Features
 * Routes system
 * Server-side rendering
 * Generators and destroyers for code scaffolding
 * I/O transitions for all Views
 * Convention over configuration *([+](http://en.wikipedia.org/wiki/Convention_over_configuration))*
 * Automagic naviagation mechanism
 * Powerful build system *(on top of [Polvo](http://github.com/serpentem/polvo)
 and [FsUtil](http://github.com/serpentem/fs-util))*
 * Simplistic JSON-Rest interface for models

# Issues
Do not hesitate to open a feature request or a bug report.
> https://github.com/serpentem/theoricus/issues

# Mailing List
A place to talk about it, ask anything, get in touch. Luckily you'll be answered
sooner than later.

> https://groups.google.com/group/theoricus

## Dev Mailing List

Got your hands into the source? We're here to help you.

> https://groups.google.com/group/theoricus-dev


# Docs
  - [Installing](#installing)
  - [Help](#help)
    - [Scaffolding new app](#scaffolding)
    - [Starting up](#starting-up)

## More

  - [Demo Application](https://github.com/serpentem/theoricus-demo-app)
  - [Contributing](https://github.com/serpentem/theoricus/blob/master/CONTRIBUTING.md)
  - [Showcase](https://github.com/serpentem/theoricus/wiki/showcase)
  - [CHANGELOG.md](https://github.com/serpentem/theoricus/tree/master/build/CHANGELOG.md)

<a name="installing" />
# Installing

````bash
npm install -g theoricus
````

<a name="help" />
# Help

Theoricus help screen.

````bash
Usage:
  the [options] [params]

Options:
  -n, --new       Creates a new app                                        
  -g, --generate  Generates a new model, view or controller                
  -d, --destroy   Destroys a new model, view, or controller                
  -s, --start     Starts app in dev mode at localhost                      
  -c, --compile   Compiles app in dev mode                                 
  -r, --release   Releases app for production                              
  -p, --preview   Releases app for production at localhost                 
  -v, --version   Shows theoricus version                                  
  -h, --help      Shows this help screen                                   
  --rf            Use with -d [view|mvc] for deleting the whole view folder
  --src           Use with -n for use a specific theoricus version         


Examples:

  • Creating new app
    the -n <app-name>
    the -n <app-name> --src <gh-user>/<gh-repo>#<repo-branch>

  • Generating models, views and controllers
    the -g model <model-name>
    the -g view <controller-name>/<view-name>
    the -g controller <controller-name>
    the -g mvc <controller-name>
       * Models and views names are singular, controllers are plural

  • Destroying models, views and controllers
    the -d model <model-name>
    the -d view <controller-name>/<view-name>
    the -d controller <controller-name>
    the -d mvc <controller-name>
    the -d mvc <controller-name> --rf
       * Models and views names are singular, controllers are plural
````

<a name="getting-started" />
## Scaffolding
To scaffold a new working project:

````bash
the -n myawesomeapp
````

It'll produce the following structure:

````bash
myawesomeapp
├── public
├── src
│   ├── app
│   │   ├── app.coffee
│   │   ├── config
│   │   │   ├── routes.coffee
│   │   │   └── settings.coffee
│   │   ├── controllers
│   │   │   ├── app_controller.coffee
│   │   │   └── pages.coffee
│   │   ├── models
│   │   │   ├── app_model.coffee
│   │   │   └── page.coffee
│   │   └── views
│   │       ├── app_view.coffee
│   │       └── page
│   │           ├── container.coffee
│   │           └── index.coffee
│   ├── styles
│   │   ├── pages
│   │   │   ├── container.styl
│   │   │   └── index.styl
│   │   └── shared
│   │       └── _bootstrap.styl
│   └── templates
│       └── page
│           ├── container.jade
│           └── index.jade
├── vendors
├── README.md
├── makefile
├── package.json
└── polvo.coffee
````

<a name="starting-up" />
## Starting up

````bash
cd myawesomeapp
the -s
````

Visit the url [http://localhost:11235](http://localhost:11235) and you should
see a success status.