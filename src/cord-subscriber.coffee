#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

require('yang-js').register()

module.exports = require('../schema/cord-subscriber.yang').bind {

  '/{subscriber}':
    # auto-computed properties
    'device/subscriber': -> @get '../..' 

    # action bindings
    'device/create': (input, resolve, reject) -> reject "TBD"
    'device/update': (input, resolve, reject) -> reject "TBD"
    'device/delete': (input, resolve, reject) -> reject "TBD"

  '/{subscriber-controller}':
    # auto-computed properties
    'related': -> new Error "will return related objects once implemented"

    # action bindings
    'features/update': (input, resolve, reject) -> reject "TBD"
    'identity/update': (input, resolve, reject) -> reject "TBD"
    
}    

