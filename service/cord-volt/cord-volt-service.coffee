require 'yang-js'

module.exports = require('./cord-volt-service.yang').bind {

  '/controller/subscriber/outflow': ->
    @debug "auto-compute subscriber/outflow property"
    tags = @get('../tags')
    serial = @get("/volt:controller/device/uplink[tag = #{tags.outer}]/../link[tag = #{tags.inner}]/serial")
    @debug "found device serial: #{serial} using VLAN #{tags.outer}/#{tags.inner}"
    @content = @get("/volt:controller/port[link = '#{serial}']/id")

}
