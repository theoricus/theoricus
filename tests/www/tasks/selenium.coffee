path = require 'path'
spawn = (require 'child_process' ).spawn
colors = require 'colors'
argv = (require 'optimist').argv

selenium = null

start = exports.start = ( after_start ) ->
  console.log '\n\nStarting Selenium\n'.bold.grey

  selenium_path = path.join __dirname, '..', 'services'
  params = [
    '-jar'
    'selenium-server-standalone-2.33.0.jar'
    '-Dwebdriver.chrome.driver=chromedriver'
  ]
  options = cwd: selenium_path, stdio: 'inherit'

  selenium = spawn '/usr/bin/java', params, options

exports.stop = -> do selenium?.kill

# auto start / shutdown
if argv.start
  start null