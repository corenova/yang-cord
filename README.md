# yang-cord
YANG model-driven CORD

This is a **work-in-progress** effort to create [YANG](http://tools.ietf.org/html/rfc6020) data models for
the CORD project and deliver flexible service compositions.

You may contact Larry Peterson <llp@onlab.us> and Peter Lee
<peter@corenova.com> to learn more about this initiative and find out how you can help.

## Installation

```bash
$ npm install yang-cord
```

## Getting Started

Following the installation, you can **start** an instance of the YANG model-driven REST API web server. It utilizes [yang-express](http://github.com/corenova/yang-express) middleware framework built on Express.js to provide dynamic YANG model-driven API routing capability.
```bash
$ npm start

> yang-cord@1.0.1 start /home/peter/yang-cord
> node lib/server.js

mounted 'cord-core' model
mounted 'xos-core' model
[cord-core] calling GET on /cord-core:subscriber
```

## Reference Guides

For more information on **interacting with the REST API endpoints**, please refer to the [API Overview](./doc/api-overview.md) documentation found in the `./doc` folder.

For more information on **current YANG models for XOS and CORD**, please refer to the [Model Overview](./schema/README.md) documentation found in the `./schema` folder.

For more information on **controller logic and dynamic interfaces**, please refer to the [Source Overview](./src/README.md) documentation found in the `./src` folder.

## Tests

To run the test suite, first install the dependencies, then run `npm
test`:
```
$ npm install
$ npm test
```
Mocha test suite is currently under development...

## LICENSE
  [Apache 2.0](LICENSE)

