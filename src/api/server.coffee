#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

yang = require('yang-js')
argv = require('minimist')(process.argv.slice(2))

require('yang-express').run {

  port: argv.port || 5050
  models: [
    yang.require 'cord-core'
    yang.require 'xos-core'
  ]
  data: require '../../sample-data.json'

}
