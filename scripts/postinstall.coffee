fsu = require 'fs-util'
path = require 'path'

# copy lodash to www/vendors
from = path.join __dirname, '..', 'node_modules', 'lodash', 'lodash.js'
to = path.join __dirname, '..', 'www', 'vendors', 'lodash.js'

fsu.cp from, to