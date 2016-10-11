# Example Service for CORD/XOS

This is an example implementation documentation for providing a quick
walk-through on composing and on-boarding service modules onto
the CORD/XOS platform.

You may contact Larry Peterson <llp@onlab.us> and Peter Lee
<peter@corenova.com> to learn more about this initiative and find out
how you can help.

## Installation

There is no need to run a separate installation as it comes bundled as
part of [yang-cord](http://github.com/corenova/yang-cord) project
repository.

If you have cloned the repository, you should first run: `npm install`
in order to initialize this example service package with dependencies.

## Example Service Composition Tutorial

Before getting started with the Example Service tutorial, you should
first take a look at [Composing Services](../README.md) reference
guide to get a high-level overview of the package assets that we'll be
working with.

1. [Define the Service Model](#define-the-service-model)
2. [Define the Controller Logic](#define-the-controller-logic)
3. [Define the Package Manifest](#define-the-package-manifest)
4. [Build the Package](#build-the-package)
5. [Test on XOS](#test-on-xos)

### Define the Service Model

The [example-service.yang](./example-service.yang) is the primary file
for describing the Example Service Controller configuration data
model.

As described in [Composing Service](../README.md) guide, the primary
sections of importance in creating a new Service Model is defining the
`container controller` section as well as `augment
"/xos:tenant/cord/subscriber"` section.

### Define the Controller Logic

The [example-service.coffee](./example-service.coffee) is the primary
file for binding control logic to the Example Service data
model. While this step is completely *optional* during prototyping, it
plays an important role when this Service package is deployed into an
actual runtime environment. The control logic bindings serve as the
*glue* which provides operational mapping to perform **actions** via
accessors, observers, and synchronizers.

Additional concrete examples and documentation for expressing control logic
bindings will be *coming soon*...

### Define the Package Manifest

The [package.json](./package.json) is the primary file for describing
the Example Service package configuration.

In general, most CORD/XOS service package will have similar
configuration with minor variations in terms of service specific
metadata.

The key package attributes for customization are as follows:

- name
- version
- author
- license
- description
- keywords
- dependencies
- scripts
- controller*
- models*

### Build the Package

```bash
$ npm run build
```

The above command will execute the `build` related scripts defined
inside `package.json`. Typically, it will compile any `*.coffee` files
found inside the package and generate the `swagger.yaml` API
specifications for the service controller. In the future, this step
will likely be replaced with the
[yang-forge](http://github.com/corenova/yang-forge) utility.

### Test on XOS

```bash
$ NODE_ENV=test npm start
```

The above command internally executes `xos example-service` which will
basically start an instance of the XOS Controller (which uses
[yang-express](http://github.com/corenova/yang-express)) and
dynamically load the Example Service data model into the runtime
execution.

Since `example-service` YANG module has additional dependencies for
`cord-tenant` and `xos-slice` (among others), these dependent YANG
modules will be automatically resolved and loaded into the runtime
instance.

The default `initializer` for the service will use the `config`
module, which will look for environmental configuration data in the
package's `config` directory. You can specify any configuration state
to be used at initialization stage across all the YANG modules that
the Example Service depends on. This means that you can customize the
exact configuration state of the XOS Controller runtime during your
testing to suit your service module's testing requirements. Another
way to look at this is to consider that you're running your testing on
a model-complete CORD/XOS emulation layer.
