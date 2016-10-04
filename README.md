# YANG model-driven CORD

This is a **work-in-progress** effort to create
[YANG](http://tools.ietf.org/html/rfc6020) data models for the
[CORD](http://opencord.org) project and deliver flexible service
compositions.

You may contact Larry Peterson <llp@onlab.us> and Peter Lee
<peter@corenova.com> to learn more about this initiative and find out
how you can help.

## Installation

```bash
$ npm install yang-cord
```

## Getting Started

Following the installation, you can **start** an instance of the YANG
model-driven REST API web server. It utilizes
[yang-express](http://github.com/corenova/yang-express) middleware
framework built on [Express.js](http://expressjs.com) to provide
dynamic YANG model-driven API routing capability.

```bash
$ npm start

> yang-cord@1.2.0 start /home/plee/hack/yang-cord
> bin/xos -I cord-tenant -I volt-service

XOS Controller started with:
info:
  title: CORD (Central Office Re-architected as a Datacenter)
  description: YANG model-driven CORD
  version: '1.0'
  contact:
    name: Peter Lee
    url: 'http://github.com/corenova/yang-cord'
    email: peter@corenova.com
  license:
    name: Apache-2.0
router:
  - name: ietf-yang-library
  - name: xos-controller
  - name: cord-tenant
  - name: volt-service
port: 5000
hostname: zcore
```

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
      -p, --port <number>        Run XOS Controller on <port>
      -I, --include [module...]  Add YANG module to XOS runtime
```

You can optionally load various YANG modules dynamically during
runtime, such as `cord-tenant`, `volt-service`, `vsg-service`,
`xos-slice`, etc. By default, it runs with `xos-controller` only. If a
given target module requires other dependency modules, they will be
loaded dynamically (such as `xos-slice` which is a dependency to
`vsg-service`).

The `bin/xos` CLI utility uses default configurations found in
`config` directory. To run it with *test data* and expose some
*runtime debug output* you can use environmental variables as follows:

```bash
$ NODE_ENV=test DEBUG=yang:model,yang:express bin/xos -I cord-tenant -I volt-service -I vsg-service
```

The current implementation auto-generates **200** unique REST API
endpoints providing dynamic `POST/GET/PUT/PATCH/DELETE/OPTIONS`
operations on each endpoint. Please refer to
[yang-express](http://github.com/corenova/yang-express) to learn more
about *YANG model-driven REST API middleware routing* framework.

## YANG Models

### XOS Core Models

- [xos-controller.yang](./schema/xos-controller.yang)
- [xos-types.yang](./schema/xos-types.yang)
- [xos-topology.yang](./schema/xos-topology.yang)
- [xos-slice.yang](./schema/xos-slice.yang)
- [xos-package.yang](./schema/xos-package.yang)

### CORD Models

- [cord-tenant.yang](./schema/cord-tenant.yang)

### Service Models

- [volt-service.yang](./services/yang-volt/volt-service.yang)
- [vsg-service.yang](./services/yang-vsg/vsg-service.yang)

For additional information on working with YANG Models, please refer
to [Modeler's Guide](./schema/README.md).

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

