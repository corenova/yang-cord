#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

Yang = require 'yang-js'
data = require '../sample-data.json'

cord = Yang.require('cord-tenant').eval(data)
volt = Yang.require('volt-service').eval(data)
vsg  = Yang.require('vsg-service').eval(data)
xos  = Yang.require('xos-controller').eval(data)

express = require('yang-express').eval {
  'yang-express:server':
    info:
      title: "CORD (Central Office Re-architected as a Datacenter)"
      description: "YANG model-driven CORD"
      version: "1.0",
      contact:
        name: "Peter Lee"
        url: "http://github.com/corenova/yang-cord"
        email: "peter@corenova.com"
      license:
        name: "Apache-2.0"
    router: [
      { name: "xos-controller" }
      { name: "ietf-yang-library" }
    ]
}
express
  .enable 'restjson'
  .enable 'openapi'

module.exports = express

# only start if directly invoked
if require.main is module
  yaml = require 'js-yaml'
  argv = require('minimist')(process.argv.slice(2))
  express.in('run').invoke(argv)
    .then (res) ->
      console.info "XOS running with:"
      console.info yaml.dump(res)
    .catch (err) -> console.error err
