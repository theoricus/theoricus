# Theoricus #

Minimalist MVC implementation for CoffeeScript.
> Version 0.2

# Features
 * Routes system
 * I/O transitions for all Views
 * Convention over configuration *([+](http://en.wikipedia.org/wiki/Convention_over_configuration))*
 * Automagic naviagation mechanism
 * Powerful build system *(on top of [CoffeeToaster](http://github.com/serpentem/coffee-toaster)
and [FsUtil](http://github.com/serpentem/fs-util))*
 * Simplistic JSON-Rest interface for models

# Issues
Do not hesitate to open a feature request or a bug report.
> https://github.com/serpentem/theoricus/issues

# Mailing List
A place to talk about it, ask anything, get in touch. Luckily you'll be answered
sooner than later.

> https://groups.google.com/group/theoricus

# About

CoffeeScript browser-based MVC(or anything alike) implementation with a
powerful'n'effortless navigation. 

It comes with a fancy comand line tool to help you compiling and scaffolding
code, programming for modern browsers was never so fun ( :

Very inspired by modern frameworks ( we don't mean only rails, but also others
goodness you can find nowadays on web ) it does a lot of magic for you.

Also worth saying we somehow "replaced" css / html / js by some sweeter sweeties

 - [Stylus](https://github.com/learnboost/stylus) (css)
 - [Jade](https://github.com/visionmedia/jade) (html)
 - [CoffeeScript](https://github.com/jashkenas/coffee-script) (js)

Have fun. :)

# Docs
  - [Installing](#installing)
  - [Usage](#usage)
    - [Scaffolding new app](#scaffolding)
    - [Starting up](#starting-up)
  - [Demo Application](#demo-app)
  - [Contributing](#contributing)
   - [Setup](#setup)
   - [Branching](#branching)
   - [Committing](#committing)
   - [Pull Requests](#pull-requests)
   - [Building](#building)
   - [Watching](#watching)
   - [Testing](#testing)
   - [Generating Docs](#generating-docs)
  - [Sites made with Theoricus](#cases)
  - [CHANGELOG](#changelog)

<a name="installing" />
# Installing
----

````bash
npm install -g theoricus
````

<a name="usage" />
# Usage
----

Theoricus help screen.

````bash
Usage:
  theoricus new      path
  theoricus add      model|view|controller|mvc 
  theoricus rm       model|view|controller|mvc 
  theoricus start    
  theoricus compile  
  theoricus index    

Options:
             new   Creates a new working project in the file system.
             add   Generates a new model|view|controller file.
              rm   Destroy some model|view|controller file.
           start   Starts app in watch'n'compile mode at http://localhost:11235
         compile   Compile app to release destination.
           index   Index the whole application to a static non-js version.
         version   Show theoricus version.
            help   Show this help screen.
````

<a name="getting-started" />
## Scaffolding
To scaffold a new working project:

````bash
theoricus new myawesomeapp
````

It'll produce the following structure:

````bash
myawesomeapp
|-- app
|   |-- app_controller.coffee
|   |-- app_model.coffee
|   |-- app_view.coffee
|   |-- controllers
|   |   `-- mains.coffee
|   |-- models
|   |   `-- main.coffee
|   |-- static
|   |   |-- _mixins
|   |   |   |-- jade
|   |   |   `-- stylus
|   |   |       `-- global_mixins.styl
|   |   `-- main
|   |       |-- index.jade
|   |       `-- index.styl
|   `-- views
|       `-- main
|           `-- index.coffee
|-- config
|   |-- app.coffee
|   `-- routes.coffee
`-- public
    |-- app.css
    |-- app.js
    `-- index.html
````

<a name="starting-up" />
## Starting up

````bash
cd myawesomeapp
theoricus start
````

Visit the url [http://localhost:11235](http://localhost:11235) and you should
see a success status.

<a name="demo-app" />
# Demo Application
----

There's a basic demo application here: <BR>
https://github.com/serpentem/theoricus-demo-app

<a name="contributing"/>
# Contributing
----

<a name="setup"/>
## Setting everything up

Environment setup is simple achieved by:

````bash
  git clone git://github.com/serpentem/theoricus.git
  cd theoricus && git submodule update --init
  npm link
````

<a name="branching"/>
## Branching

Before anything else, start a named branch. If you're fixing the View rendering
routine, this would be nice:

`````
git checkout -b fixing-view-rendering
[...comits...]
[pull request]
````

Always isolate your implementations into separated branches, it'll make it easy
for others to look inside of it, easy to open pull requests (and those to get
merged), easy to discuss the proposal or adopted solution, and so on.

<a name="committing"/>
## Committing

Try to not repeat yourself, *never* explain **what** you did -- it's easy to see
with a simple DIFF. 

Instead, explains **WHY** you did it -- put into words the reasons that led you
to implement something, expose the scenario, the studied cases, be solid.

The more other people can understand your *reasons*, the more they can get
together with your idea.

<a name="pull-requests"/>
## Pull Requests

Pull requests must to have two requirements:

 * 1) A **problem**, a **need**, an **improvement**, a **proposal**, etc.
 * 2) A **solution** for requirement #1.

Ideally one pull request will point to a specific branch aiming to fix or
implement something *specifically*. Never combine more than one *problem* or
*solution* into one single branch or pull request.

This way the noise is crucially reduced and things can be discussed clearly.
Poorly specified pull requests are hard to understand, to diff and to merge.

A good and very simple template message for new Pull Requests:


Subject: [Short description of what you've done]

````
The [problem/feature/improvement/etc]:
[...solid explanation of the issue...]

The solution:
[...clearly explanation of the fix...]
````

Don't be shy, try to avoid short messages here as well in the commits.

NOTE: To open a Pull Request please refer to the [Testing](#testing) section.

<a name="building"/>
## Building

Builds the release files inside the `lib` folder.

````bash
  make build
````

<a name="watching"/>
## Watching'n'Compiling

Starts watching in auto-compile mode.

````bash
  make watch
````

<a name="testing"/>
## Testing

Tests ( for cli and framework ) are being created in branch "tests", currently we are using [mocha](https://github.com/visionmedia/mocha) and [should.js](https://github.com/visionmedia/should.js/)

For each new feature in Theoricus, a new example should be made in the demo
application to elucidate things.

Please keep the examples in the *Demo Application* up to date with changes you make in *Theoricus*, ideally when openning a pull request, open one in *Theoricus* and on in the *Demo App*.

To run the tests run `make test`

<a name="docs"/>
## Generating Docs

There are two distinct documentatios:

 * Theoricus (in browser code)
````bash
make docs.www
````

 * Theoricus CLI (your command line lover)
````bash
make docs.cli
````

<a name="cases" />
# Sites Made with Theoricus
----

## Codeman
* URL: http://www.codeman.co/
* Source: https://github.com/giuliandrimba/codeman
* Credits: [Giulian Drimba](https://github.com/giuliandrimba)

## Dolce & Gabbana - Brand Site FW 13
* URL: http://dolcegabbana.com/dg/
* Credits: [hems](https://github.com/hems) / [grifo.tv](https://github.com/grifotv) / [Scott](https://github.com/ashmore11) / [Hi-ReS!](https://github.com/hi-res)

<a name="installing" />
# Changelog
 * [CHANGELOG.md](https://github.com/serpentem/theoricus/tree/master/build/CHANGELOG.md)
