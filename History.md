0.2.21 / 2013-07-29
===================
 * Setting up environment for functional tests on the `www` folder
 * Setting up tests coverage and badge from coveralls.io
 * Adding `--base` flag in order to run theoricus without entering the app dir

## 0.2.20 / 2013-07-04
===================
 * Adding postinstall hook to replace symlinks functionality (closes [#62](https://github.com/serpentem/theoricus/issues/62))

## 0.2.19 / 2013-06-30
===================
 * Upgrading outdated dependencies

## 0.2.18 / 2013-06-30
===================
  * Embedding indexing system (by (snapshooter)[https://github.com/serpentem/snapshooter])

## 0.2.17 / 2013-06-30
===================
  * Fixing release mode, forking Polvo the right way
  * Updating `app_skel` to include `lodash` as vendor

## 0.2.16 / 2013-06-26
===================
  * Fixing `instantiate_method` in Model, referencing Factory class from the
  right place. (closes [#58](https://github.com/serpentem/theoricus/pull/58))

## 0.2.15 / 2013-06-13
===================
  * Fixing method stdout piping between Server REPL and Polvo
  * Rolling back default mode to `cs` in REPL

## 0.2.14 / 2013-06-13
===================
  * Introducing Theoricus REPL, just run `the -s` as you do, and done

## 0.2.13 / 2013-06-13
===================
  * Adding `on_activate` method to Process
  * Synchronizing View _render method, to update the window's title always
  when process get activated. A process will render a view only one time, but
  can get activated many times.
  * Handling single result (non-array) in model's rest calls

## 0.2.12 / 2013-06-08
===================
 * Fixing variable scope in `View._render`
 * Saving local bidged method for `View._on_resize` in order to unbind it later
 * Removing circular dependency between Factory and Model (closes [#39](https://github.com/serpentem/theoricus/pull/39)))
 * Merging `giuilian/hotfix-model-instantiate`, which fixed the instantiation
 of multiple recordos, waiting for the performed async operations

## 0.2.11 / 2013-06-07
===================
 * Stop overwriting Route.at property on processes search mechanisms
 * Exposing params, data and view properties to templates (closes #45)
 * Removing all `ArrayUtil.find` calls from `Processes` class, in favor of
 lodash simpler calls (better late than never), this will clear things up a bit

## 0.2.10 / 2013-06-06
===================
 * Fixing critical error in processes related to dependencies resolution
 * Removing duplicated destroy method in View

## 0.2.9 / 2013-06-04
===================
 * Adding possibility to call 'navigate' in the middle of a Controller action
 * Automatically choosing action 'index' in Router, when no action is provided
 * Binding View `on_resize` scope the View to be practical

## 0.2.8 / 2013-06-01
===================
  * Properly handling broken requests / scripts not found with RequireJS
  * Implementing default routing based on 'controller/action' behavior when
  there's not route defined (Controller must to exist)
  * Implementing 404 route on Router
  * Simplyfing core flow process -> controller -> view and cleaning methods
  signatures

## 0.2.7 / 2013-06-01
===================
 * Fixing routes with dynamic parameters
 * Switching to named-params instead of ordered-params
 * Fixing model instantiation
 * Adding flag to enable/disable model's automatic validation
 * Providing route params for all templates by default
 * Adding hidden option `--dev` when creating new projects

## 0.2.6 / 2013-05-28
===================
 * Fixing app_skel according last fixes related inflections singularization and
 pluralization

## 0.2.5 / 2013-05-28
===================
 * Fixing model rest calls (closes [#29](https://github.com/serpentem/theoricus/pull/29))
 * Adding navigate's shortcut to controller  (closes [#30](https://github.com/serpentem/theoricus/pull/30))

## 0.2.4 / 2013-05-28
===================
 * Removing stupid `console.log` call

## 0.2.3 / 2013-05-27
===================
  * Implementing Theoricus bridge, favoring local verions over the global one
  * Removing makefile routines, favoring win users as well with simplicity
  * Improving `--src` usage, implementing some hotfixes and setting default
  behavior to `git submodules`
  * Adding the `--nogitsub` option to avoid git sub modules

## 0.2.2 / 2013-05-24
===================
  * Fixing pluralizations/singularizations everywhere it applies (closes [#27](https://github.com/serpentem/theoricus/pull/27))
  * Adding a title property for view in order to improving SEO (closes [#26](https://github.com/serpentem/theoricus/pull/26))

## 0.2.1 / 2013-05-23
===================
 * Quick fix in makefile regarding version evaluation

## 0.2.0 / 2013-05-22
===================
 * Integrating project with [Polvo](https://github.com/serpentem/polvo)
 * Adding LiveReload capabilities for everything
 * Improving code style to CJS signature (on top of Polvo)
 * Converting everything to AMD modules in background (on top of Polvo)
 * Updating CLI signature to keep it simple and flexible
 * Adding the option for creating new apps based on your own Theoricus repo
 * Improving the whole new project's creation routine
 * Re-modeling app skel to contain README, makefile and package.json files
 * Externalizing all build options into the `polvo.coffee` file (on top of Polvo)
 * A bunch of things I can't remember

## 0.1.8 / 2012-12-23
===================
 * Implementing vendors management (fix [#4](https://github.com/serpentem/theoricus/issues/4)).

## 0.1.7 / 2012-12-22
===================
 * Creating `CHANGELOG.md` file (better later than never).