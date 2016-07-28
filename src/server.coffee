require('events').EventEmitter.defaultMaxListeners = 100
yang = require('yang-js').register()

require('yang-express').run {

  port: 5050
  models: [
    yang.require 'cord-core'
    yang.require 'xos-core'
  ]
  data: require '../sample-data.json'

}
