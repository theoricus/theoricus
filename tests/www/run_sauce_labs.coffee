conf = 
  hostname: 'localhost'
  port: 4445
  user: user = process.env.SAUCE_USERNAME
  pwd: key = process.env.SAUCE_ACCESS_KEY

base_url = "http://localhost:8080/"
mark_as_passed = (require './utils/mark-as-passed').config user, key

(require './run').test 'sauce labs', conf, base_url, mark_as_passed