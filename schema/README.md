# Modeling Guide

This is a **work-in-progress** documentation capturing current models
for XOS and CORD. It's currently *exploratory* and contains
free-flowing commentary regarding observations from reviewing the
originating reference code repository as well as any deviations and
recommendations on expressing them as YANG models.

## Modeling Conventions

TBD...

## Platform Data Models

### xos-controller

- YANG schema: [xos-controller.yang](./xos-controller.yang)
- Source reference: [opencord/xos](http://github.com/opencord/xos)

This YANG module is the **primary** module that houses all XOS related
core data models.  The models for these came from `xos/core/models`
directory in the XOS repository. It currently captures the `Tenant`,
`Subscriber`, `Provider`, and `Service` models.

This module also provides the `/core`, `/service`, and `/tenant`
configuration trees which serve as *placeholder* containers for
additional modules to *augment* additional configuration nodes.

When loaded by `xos` (by default) it routes following API endpoints:

Explicit | Prefixed | Implicit
--- | --- | ---
/xos-controller:core    | /xos:core    | /core
/xos-controller:service | /xos:service | /service
/xos-controller:tenant  | /xos:tenant  | /tenant

The contents of these endpoints are dynamically composed based on
whether additional YANG modules are loaded into the runtime
environment.

### xos-slice

- YANG schema: [xos-slice.yang](./xos-slice.yang)
- Source reference: [opencord/xos](http://github.com/opencord/xos)

This YANG module provides the `Slice` abstraction and is dynamically
loaded by the `Service` modules as needed. Internally, it utilizes the
`opnfv-iaas` YANG module from the
[OPNFV Promise](http://github.com/opnfv/promise) project for the
various NFVI resource models.

It does not contain any configuration nodes at the module itself, but
instead *augments* into `xos-controller:core` configuration tree as
well as various `opnfv-iaas:controller` data tree across `compute` and
`fabric` configuration trees.

When loaded by `xos` it provides the additional API endpoint:

Explicit | Prefixed | Implicit
--- | --- | ---
/xos-controller:core/xos-slice:slice | /xos:core/xslice:slice | /core/xslice:slice

### xos-topology

- YANG schema: [xos-topology.yang](./xos-topology.yang)
- Source reference: [opencord/xos](http://github.com/opencord/xos)

This YANG module provides the `Deployment`, `Site`, `Node`, `User`,
and `Template` models. They are currently available as conceptual
entities that can be utilized for managing the topology model for
a given platform deployment.

It does not contain any configuration nodes at the module itself, but
instead *augments* into `xos-controller:core` configuration tree.

When loaded by `xos` it provides the additional API endpoints:

Explicit | Prefixed | Implicit
--- | --- | ---
/xos-controller:core/xos-topology:deployment | /xos:core/xtop:deployment | /core/xtop:deployment
/xos-controller:core/xos-topology:site       | /xos:core/xtop:site       | /core/xtop:site
/xos-controller:core/xos-topology:node       | /xos:core/xtop:node       | /core/xtop:node
/xos-controller:core/xos-topology:user       | /xos:core/xtop:user       | /core/xtop:user
/xos-controller:core/xos-topology:template   | /xos:core/xtop:template   | /core/xtop:template

### xos-types

- YANG schema: [xos-types.yang](./xos-types.yang)
- Source reference: [opencord/xos](http://github.com/opencord/xos)

This YANG module provides various common type definitions used within
XOS. The following definitions are provided:

- unique-identifier
- flow-identifier
- network-identifier
- mac-address
- bandwidth
- vlan
- isoluation
- access-role
- certificate

It is *imported* by various YANG modules within the project to ensure
appropriate type validation mappings.

It does not contain any configuration tree nodes within the module.

### xos-package

- YANG schema: [xos-package.yang](./xos-package.yang)
- Source reference: [opencord/xos](http://github.com/opencord/xos)

This YANG module provides the `Package` model for enabling XOS
Controller to assemble and on-board various `Service` packages. It is
still very much *work-in-progress* and currently not utilized in the
project. Eventually, it will be integrated with
[yang-forge](http://github.com/corenova/yang-forge) packaging tool and
play an important role in building, deploying, and publishing the
various XOS/CORD specific `Service` packages into a centralized
repository.

### cord-tenant

- YANG schema: [cord-tenant.yang](./cord-tenant.yang)
- Source reference: [opencord/olt](http://github.com/opencord/olt)

This YANG module provides the `Subscriber` model for representing the
CORD Tenant. It contains basic properties for describing the CORD
Subscriber but its main role is to serve as a *placeholder* entity for
various `Service` packages to dynamically *augment* service-specific
attributes into the CORD Subscriber entity.

It does not contain any configuration nodes at the module itself, but
instead *augments* into `xos-controller:tenant` configuration tree.

When loaded by `xos` it provides the additional API endpoints:

Explicit | Prefixed | Implicit
--- | --- | ---
/xos-controller:tenant/cord-tenant:cord | /xos:tenant/cord:cord | /tenant/cord:cord
/xos-controller:tenant/cord-tenant:cord/subscriber | /xos:tenant/cord:cord/subscriber | /tenant/cord:cord/subscriber

It essentially serves as the primary entity for mapping the CORD
Subscriber to one or more `Service` subscriptions.

## Service Data Models

The following `Service` models are currently provided inside the
`yang-cord` repository and demonstrates how to assemble/compose a new
`Service` to be deployed into the XOS Controller. For additional
information regarding [Composing Services](../service/README.md) be
sure to review the documentation found inside the `service` folder.

### cord-volt-service

- YANG schema: [cord-volt-service.yang](../service/cord-volt/cord-volt-service.yang)
- Source reference: [opencord/olt](http://github.com/opencord/olt)

This YANG module implements the [XOS Service](./xos-controller.yang)
model and provides the `controller` configuration tree for managing
the VOLT agent. It currently does **not** augment into
`xos-controller` but provides the `controller` configuration directly
by the module.

It further *augments* into
`xos-controller:tenant/cord/subscriber` entity to add additional
service-specific attributes.

When loaded by `xos` it provides the additional API endpoints:

Explicit | Prefixed | Implicit
--- | --- | ---
/cord-volt-service:controller | /volt:controller | N/A
/cord-volt-service:controller/subscriber | /volt:controller/subscriber | N/A
/cord-volt-service:controller/device | /volt:controller/device | N/A
/cord-volt-service:controller/port | /volt:controller/port | N/A
/xos-controller:tenant/cord-tenant:cord/cord-tenant:subscriber/cord-volt-service:service | /xos:tenant/cord:cord/cord:subscriber/volt:service | /tenant/cord:cord/subscriber/volt:service

### cord-vsg-service

- YANG schema: [cord-vsg-service.yang](../service/cord-volt/cord-vsg-service.yang)
- Source reference: [opencord/vsg](http://github.com/opencord/vsg)

This YANG module implements the [XOS Service](./xos-controller.yang)
model and provides the `controller` configuration tree for managing
per subscriber VSG instances. It currently does **not** augment into
`xos-controller` but provides the `controller` configuration directly
by the module.

This YANG module has additional dependencies to the
`cord-volt-service` as well as the `xos-slice` module. These
dependencies are dynamicaly resolved during runtime so that the needed
models are made available to this `Service` module on-demand.

It further *augments* into
`xos-controller:tenant/cord/subscriber` entity to add additional
service-specific attributes.

When loaded by `xos` it provides the additional API endpoints:

Explicit | Prefixed | Implicit
--- | --- | ---
/cord-vsg-service:controller | /vsg:controller | N/A
/cord-vsg-service:controller/subscriber | /vsg:controller/subscriber | N/A
/cord-vsg-service:controller/gateway | /vsg:controller/gateway | N/A
/cord-vsg-service:controller/port | /vsg:controller/port | N/A
/xos-controller:tenant/cord-tenant:cord/cord-tenant:subscriber/cord-vsg-service:service | /xos:tenant/cord:cord/cord:subscriber/vsg:service | /tenant/cord:cord/subscriber/vsg:service

