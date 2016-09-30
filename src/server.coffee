#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

config = require 'config'
Yang = require 'yang-js'
yaml = require 'js-yaml'

xos = Yang.import('xos-controller').eval(config)
server = require('yang-express').eval(config)
server
  .enable 'restjson'
  .enable 'openapi'

module.exports = server

server.once 'run', (opts={}) ->
  includes = [].concat(opts.include).filter(Boolean)
  for include in includes
    try Yang.import(include).eval(config)
    catch e
      console.error e
      throw new Error "unable to include '#{include}' YANG module, check your local 'package.json' for models"
    server.in('server/router').merge name: include
  server.in('run').invoke(opts)
  .then (res) ->
    console.info "XOS Controller running with:"
    console.info yaml.dump(res)
  .catch (err) -> console.error err
