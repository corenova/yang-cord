# YANG model-driven CORD

This implementation is an on-going effort to create
[YANG](http://tools.ietf.org/html/rfc6020) data models for the
[CORD](http://opencord.org) project and deliver flexible service
compositions.

One of the key objectives is to provide an **emulation layer** of the
CORD platform for service developers to experience the runtime
environment and perform rapid integrations of their capabilities.

You may contact Larry Peterson <llp@onlab.us> and Peter Lee
<peter@corenova.com> to learn more about this initiative and find out
how you can help.

## Installation

```bash
$ npm install -g yang-cord
```

The preferred installation is *global* for easy access to the `xos`
utility but can also be used as a dependency module to utilize the XOS
Controller and associated YANG models as part of your project.

## Quick Start

```bash
$ npm start
```

The above example will import the various XOS extension modules and
start an instance of
[yang-express](http://github.com/corenova/yang-express) middleware web
server listening on port 5000 with `restjson` and `openapi` features
enabled.

_An option `--port` is provided to specify the port to listen on, it can be used with:_

```
npm start -- --port 3000
```

You can also use the provided `bin/xos` CLI utility directly to start
an instance of the XOS Controller.

```bash
$ bin/xos -h
  Usage: xos [options]

  Options:
      -p, --port <number>      Run XOS Controller on <port>
```

Using the `bin/xos` CLI utility, you can have flexible control around
loading additional YANG modules dynamically during runtime, such as
`cord-tenant`, `cord-volt-service`, `cord-vsg-service`, `xos-slice`,
etc. By default, it runs with `xos-controller` only. If a given target
module requires other dependency modules, they will be loaded
dynamically (such as `xos-slice` which is a dependency to
`cord-vsg-service`).

The `bin/xos` CLI utility uses default configurations found in
`config` directory. To run it with *test data* and expose some
*runtime debug output* you can use environmental variables as follows:

```bash
$ NODE_ENV=test DEBUG=yang:express bin/xos cord-tenant cord-volt-service cord-vsg-service
```

During troubleshooting/debugging, it may be helpful to turn on much
more verbose debug output via setting `DEBUG=yang:*` or even
`DEBUG=*`. It generates significant amount of debugging output, so it
is recommended to only increase the verbosity to diagnose specific
runtime errors.

For more information on programmatic usage, be sure to take a look at
the References listed below.

## References

This module is a YANG model-driven data module, which is essentially a
composition of the [YANG Schema](./schema/xos-controller.yang) and
[Control Binding](./src/xos-controller.coffee). It is designed to
model the XOS/CORD platform and can be utilized with or without any
actual infrastructure dependencies.

- [Apiary Documentation](http://docs.yangcord.apiary.io)
- [Composing Services](./service/README.md)
- [Modeling Conventions](./schema/README.md)
- [Using YANG with JavaScript](http://github.com/corenova/yang-js)
- [Using Model API](http://github.com/corenova/yang-js#model-instance)
- [Storing Data](http://github.com/corenova/yang-store)
- [Expressing Interfaces](http://github.com/corenova/yang-express)
- [Automating Documentation](http://github.com/corenova/yang-swagger)

## YANG Models

There are a number of YANG modules inside this repository, with the
[xos-controller.yang](./schema/xos-controller.yang) serving as the
primary module. The other modules serve a supporting role by
dynamically *augmenting* the XOS Controller with additional
capabilties as they are conditionally loaded into the runtime.

- [xos-controller.yang](./schema/xos-controller.yang)
- [xos-topology.yang](./schema/xos-topology.yang)
- [xos-slice.yang](./schema/xos-slice.yang)
- [xos-package.yang](./schema/xos-package.yang)
- [xos-types.yang](./schema/xos-types.yang)
- [cord-tenant.yang](./schema/cord-tenant.yang)

For additional information on working with XOS/CORD YANG Models, please refer
to the [Modeling Conventions](./schema/README.md) guide.

## Service Packages

- [cord-volt](./service/cord-volt)
- [cord-vsg](./service/cord-vsg)
- [example-service](./service/example-service)

## Tests

To run the test suite, first install the dependencies, then run `npm
test`.

```
$ npm install
$ npm test
```
Mocha test suite is currently under development...

## LICENSE
  [Apache 2.0](LICENSE)

