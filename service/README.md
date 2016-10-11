# Composing Services

Service on-boarding is a dynamic operation in the lifecycle of a
YANG-CORD deployment. This means that design/develop/test workflows
associated with a given Service assembly and on-boarding can take
place completely de-coupled from an actual deployment of the XOS/CORD
platform.

The *guiding design principle* to keep in mind during Service design
is to view the rest of the system from the lense of the Service itself
being at the **center of the universe**. What that means is that the
Service is the **primary** actor as far as the Service itself is
concerned and it is simply *tapping into* various Models and
Operational facilities that it needs from its environment for its own
self-managed operation.

Currently there are two Service implementations [VOLT](./cord-volt)
and [VSG](./cord-vsg) already bundled as part of this project
repository. Although they are included in the `yang-cord` repository,
they have been packaged *independently* such that they can be
maintained separately in their own independent repositories (should we
choose to separate them).

For an in-depth tutorial on creating and on-boarding a new Service,
take a look at the
[Example Service Tutorial](./example-service/README.md) and follow the
example workflows.

## Package Manifest

Each Service package defines its own metadata and dependencies using
`package.json` file at the root of the package directory. It uses the
[NPM](http://npmjs.com) package manager and follows the same
conventions as defined in
[package.json](http://docs.npmjs.com/files/package.json) documentation
guide. Although most of the existing NPM package configuration
attributes are utilized *AS-IS*, there are a couple of additional
attributes defined specifically for dealing with YANG schema
dependencies across packages. For additional info on YANG schema
dependency handling, take a look at
[Working with Multiple Schemas](http://github.com/corenova/yang-js/blob/master/TUTORIAL.md#working-with-multiple-schemas)
documentation found in [yang-js](http://github.com/corenova/yang-js)
project page.

The following are the key attributes used in `package.json`
(schema-defined in [xos-package.yang](../schema/xos-package.yang)):

attribute | type | mandatory | description
--- | --- | --- | ---
name | meta:meta-identifier | true | name of the service definition
version | meta:semantic-version | true | version of the service package
license | meta:license | true | i.e. Apache-2.0
description | meta:description | false | description of the service function
author | meta:person-name | false | name of the service designer
keywords | leaf-list(meta:meta-identifier) | false | list of keywords for search
models | list(model) | at least one | YANG schema name/file mappings
controller | object([ControllerReference](#define-the-controller-reference)) | true | Service controller definitions

### Controller Reference

The Controller Reference is an additional package configuration
section specific to defining CORD/XOS Service Packages. Since a
typical YANG package bundle can contain multiple YANG schema models,
this configuration block is used to inform the XOS Controller as to
the *primary* Service Controller model along with other asset
references for use by the XOS Controller during Service on-boarding.

attribute | type | mandatory | description
--- | --- | --- | ---
model | leafref | true | name of the controller model (must be one of the entries in `models`)
initializer | meta:file-name | false | reference to model state initializer (config)
synchronizer | meta:file-name | false | reference to model synchronizer (code asset)
public-key | meta:file-name | false | reference to RSA public keyfile
private-key | meta:file-name | false | reference to RSA private keyfile

## Service Controller Model

A CORD/XOS Service Controller Model is declared as a YANG module and
is defined by establishing two distinct model-driven relationships:

1. **Extending** from XOS Service [xos-controller.yang](../schema/xos-controller.yang)
2. **Augmenting** into CORD Tenant [cord-tenant.yang](../schema/cord-tenant.yang)

What this means is that a Service Controller is *becoming* an
implementation-specific instance of a XOS Service Model, while
*infusing* additional service-specific attributes into the CORD Tenant
Model. This *pull/push* nature of YANG schema modeling is heavily
utilized throughout the platform and is a fundamental modeling
principle in creating Dynamic Service Compositions.

In turn, every Service Controller Model definition MUST `import` the
following YANG modules:

```yang
import cord-tenant { prefix cord; }
import xos-controller { prefix xos; }
```

The above two YANG modules are found in the
[yang-cord](http://github.com/corenova/yang-cord) package (external)
and you will also need to define references to these YANG models
inside your `package.json` configuration file as follows:

```json
"models": {
  "cord-tenant": "yang-cord",
  "xos-controller': "yang-cord"
}
```

These two YANG modules provide access to the CORD Tenant data models
as well as XOS Controller data models which are the basic prerequisits
for defining your own Service Controller Model. You may optionally
`import` additional YANG modules, such as `ietf-yang-types`,
`yang-meta-types`, `ietf-yang-library`, `xos-slice`, `xos-topology`,
`xos-types`, etc. depending on additional data models you need to
reference as part of your Service Controller. You can even `import`
other Service Controllers such as `yang-volt` if your Service
Controller depends on or hels to augment other existing Service
specific data models.

### Extending the XOS Service "Class"

As a general *convention* for a XOS Service Controller, the model
contains a `controller` configuration block which **uses** the
[xos:service](../schema/xos-controller.yang) grouping data schema and
**augments** the *subscriber* configuration section with its own
Service specific configuration elements. In an Object-oriented
paradigm, you can simply think of the `controller` configuration block
**inheriting** the `XOS Service Class` and **overriding** elements
with its own sub-class specific attributes.

```yang
container controller {
  uses xos:service {
    augment "subscriber" {
	  // service-specific overrides
    }
  }
  // additional service-specific configurations
}
```

### Augmenting the CORD Tenant "Class"

Additionally, the new Service Controller can *infuse* additional
service-specific attributes into the CORD Tenant data model. While
this *augmentation* is actually *optional*, it is unlikely for a new
Service Controller to be on-boarded into CORD/XOS without additional
attributes being introduced into the CORD Tenant model. Only exception
would be if you were creating a *pure* XOS Service Controller (which
may be appropriate for some use cases).

For example:

```yang
augment "/xos:tenant/cord/subscriber" {
  // my service-specific configuration nodes
  container my-service {
    leaf my-service-param { type string; }
  }
}
```

The above example would dynamically *modify* the existing CORD
Tenant's `list subscriber` data node with the Service Controller's
specific configuration entities. Basically, every CORD Subscriber
instance will now have ability to accept configuration parameters
pertaining to this Service Controller **IFF** this module was deployed
into a running XOS Controller environment.
