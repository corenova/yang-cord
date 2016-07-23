yang = require('yang-js').register()

require('yang-express').run {
  
  port: 5050
  models: [
    yang.require 'cord-core'
  ]
  data: require '../sample-data.json'
  
}
