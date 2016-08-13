#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

yang = require('yang-js')

app = require('yang-express') ->
  @set 'pkginfo', require('../../package.json')
  @set 'initial state', require('../../sample-data.json')
  @enable 'openapi', 'restjson', 'websocket'
  
  cord = @link yang.require('cord-core')
  xos  = @link yang.require('xos-core')
  
  cord.on 'update', (prop) ->
    console.log "[#{prop.path}] got updated, should consider persisting the change somewhere"
    
module.exports = app

# only start if directly invoked
if require.main is module
  path = require('path')
  argv = require('minimist')(process.argv.slice(2))
  argv.port ?= 5050
  app.listen argv.port
