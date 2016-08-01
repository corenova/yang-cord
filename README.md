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

> yang-cord@1.0.1 start /home/peter/yang-cord
> node lib/server.js

mounted 'cord-core' model
mounted 'xos-core' model
[cord-core] calling GET on /cord-core:subscriber
```

_An option `--port` is provided to specify the port to listen on, it can be used with:_

```
npm start -- --port 3000
```

## Reference Guides

- [API Guide](./src/api/README.md) - provides a walkthrough on *interacting with the REST API endpoints*
- [Modeler's Guide](./schema/README.md) - provides information on *current YANG models for XOS and CORD* and what's coming up next
- [Developer's Guide](./src/README.md) - provides technical detail on *controller logic and dynamic interfaces* and how to best leverage YANG model-driven developer tools for getting things done *fast*.

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

