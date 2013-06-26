# Changelog

## 0.2.16 - 06/26/2013
  * Fixing `instantiate_method` in Model, referencing Factory class from the
  right place. (closes [#58](https://github.com/serpentem/theoricus/pull/58))

## 0.2.15 - 06/13/2013
  * Fixing method stdout piping between Server REPL and Polvo
  * Rolling back default mode to `cs` in REPL

## 0.2.14 - 06/13/2013
  * Introducing Theoricus REPL, just run `the -s` as you do, and done

## 0.2.13 - 06/13/2013
  * Adding `on_activate` method to Process
  * Synchronizing View _render method, to update the window's title always
  when process get activated. A process will render a view only one time, but
  can get activated many times.
  * Handling single result (non-array) in model's rest calls

## 0.2.12 - 06/08/2013
 * Fixing variable scope in `View._render`
 * Saving local bidged method for `View._on_resize` in order to unbind it later
 * Removing circular dependency between Factory and Model (closes [#39](https://github.com/serpentem/theoricus/pull/39)))
 * Merging `giuilian/hotfix-model-instantiate`, which fixed the instantiation
 of multiple recordos, waiting for the performed async operations

## 0.2.11 - 06/07/2013
 * Stop overwriting Route.at property on processes search mechanisms
 * Exposing params, data and view properties to templates (closes #45)
 * Removing all `ArrayUtil.find` calls from `Processes` class, in favor of
 lodash simpler calls (better late than never), this will clear things up a bit

## 0.2.10 - 06/06/2013
 * Fixing critical error in processes related to dependencies resolution
 * Removing duplicated destroy method in View

## 0.2.9 - 06/04/2013
 * Adding possibility to call 'navigate' in the middle of a Controller action
 * Automatically choosing action 'index' in Router, when no action is provided
 * Binding View `on_resize` scope the View to be practical

## 0.2.8 - 06/01/2013
  * Properly handling broken requests / scripts not found with RequireJS
  * Implementing default routing based on 'controller/action' behavior when
  there's not route defined (Controller must to exist)
  * Implementing 404 route on Router
  * Simplyfing core flow process -> controller -> view and cleaning methods
  signatures

## 0.2.7 - 06/01/2013
 * Fixing routes with dynamic parameters
 * Switching to named-params instead of ordered-params
 * Fixing model instantiation
 * Adding flag to enable/disable model's automatic validation
 * Providing route params for all templates by default
 * Adding hidden option `--dev` when creating new projects

## 0.2.6 - 05/28/2013
 * Fixing app_skel according last fixes related inflections singularization and
 pluralization

## 0.2.5 - 05/28/2013
 * Fixing model rest calls (closes [#29](https://github.com/serpentem/theoricus/pull/29))
 * Adding navigate's shortcut to controller  (closes [#30](https://github.com/serpentem/theoricus/pull/30))

## 0.2.4 - 05/28/2013
 * Removing stupid `console.log` call

## 0.2.3 - 05/27/2013
  * Implementing Theoricus bridge, favoring local verions over the global one
  * Removing makefile routines, favoring win users as well with simplicity
  * Improving `--src` usage, implementing some hotfixes and setting default
  behavior to `git submodules`
  * Adding the `--nogitsub` option to avoid git sub modules

## 0.2.2 - 05/24/2013
  * Fixing pluralizations/singularizations everywhere it applies (closes [#27](https://github.com/serpentem/theoricus/pull/27))
  * Adding a title property for view in order to improving SEO (closes [#26](https://github.com/serpentem/theoricus/pull/26))

## 0.2.1 - 05/23/2013
 * Quick fix in makefile regarding version evaluation

## 0.2.0 - 05/22/2013
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

## 0.1.8 - 12/23/2012
 * Implementing vendors management (fix [#4](https://github.com/serpentem/theoricus/issues/4)).

## 0.1.7 - 12/22/2012
 * Creating `CHANGELOG.md` file (better later than never).