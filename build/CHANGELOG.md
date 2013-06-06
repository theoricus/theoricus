# Changelog

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