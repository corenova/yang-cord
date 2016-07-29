#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

require('events').EventEmitter.defaultMaxListeners = 100

yang = require('yang-js')

require('yang-express').run {

  port: 5050
  models: [
    yang.require 'cord-core'
    yang.require 'xos-core'
  ]
  data: require '../../sample-data.json'

}
