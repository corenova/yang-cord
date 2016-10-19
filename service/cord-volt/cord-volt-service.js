// Generated by CoffeeScript 1.11.1
(function() {
  require('yang-js');

  module.exports = require('./cord-volt-service.yang').bind({
    '/controller/subscriber/outflow': function() {
      var serial, tags;
      this.debug("auto-compute subscriber/outflow property");
      tags = this.get('../tags');
      serial = this.get("/volt:controller/device/uplink[tag = " + tags.outer + "]/../link[tag = " + tags.inner + "]/serial");
      this.debug("found device serial: " + serial + " using VLAN " + tags.outer + "/" + tags.inner);
      return this.content = this.get("/volt:controller/port[link = '" + serial + "']/id");
    }
  });

}).call(this);
