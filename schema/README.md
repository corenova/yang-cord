# Modeler's Guide

This is also a **work-in-progress** documentation capturing current
models for XOS and CORD. It's currently *exploratory* and contains
free-flowing commentary regarding observations from reviewing the
originating reference code repository as well as any deviations and
recommendations on expressing them as YANG models.

The initial effort is centered around capturing the CORD Subscriber
model and its dependent models.  We'll be reguarly updating this
document as we capture additional models from XOS/CORD repository in
the coming days.

## XOS Data Models

### xos-core 

- YANG schema: [xos-core.yang](./xos-core.yang)
- Source reference: [opencord/xos](http://github.com/opencord/xos)

This YANG module is the **primary** module that will house all XOS
related data models going forward.  The models for these came from
`xos/core/models` directory in the XOS repository.  It will eventually
house the `Service` class, the `Tenant` class, etc.  One notable
convention here is the existence of the `/api/tenant` and
`/api/service` configuration tree inside this module.  In a sense,
we're considering this YANG module to be the **master** module that
all other modules derive from and augments into this module.  You can
see this *augment* behavior in the
[cord-core.yang](./cord-core.yang) schema.

As we capture more XOS data models, we will likely organize the
additional models as separate YANG modules, such as `xos-service`,
`xos-tenant`, `xos-slice`, etc. which will be *imported* by this
module.

For now, we've captured the `TenantRoot` and `Subscriber` classes.

This module contains basic placeholder configuration data tree and
passed into `yang-express`.

## CORD Data Models

### cord-core

- YANG schema: [cord-core.yang](./cord-core.yang)
- Source reference: [opencord](http://github.com/opencord)

This YANG module is the **primary** module that will house all CORD
related data models going forward.  It currently captures the
`cord-subscriber` configuration tree and *imports* the subscriber
schema from the `cord-subscriber` YANG module. From a pure data
modeling perspective, the current originating reference implementation
has yet to achieve a clean functional separation between XOS and
CORD. This will be a key area of focus as we attempt to define a clear
degree of abstraction between the XOS models and CORD models.

This module contains subscriber-related configuration data tree and
passed into `yang-express`.

There are two main entry-points on the `subscriber` instances.  I've
defined a `list subscriber` construct directly in the `module
cord-core` which basically uses the `grouping subscriber-controller`
data model.  This means that the `cord-core` YANG module itself will
be the authorative holder of all subscriber instances.  Subsequently,
I've augmented the `xos` module at the `/api/tenant` configuration
tree to have a new `cord` tenant container along with a `node:link` to
the subscriber list within the `cord-core` YANG module.  This
convention makes it possible to access the `subscriber` instances by
directly accessing the `cord-core` module, such as
`/cord-core:subscriber` or via the `xos` module, such as
`/xos-core:api/tenant/cord/subscriber`.

### cord-device

- YANG schema: [cord-device.yang](./cord-device.yang)
- Source reference: [opencord/olt](http://github.com/opencord/olt)

This YANG module is based on the `CordDevice` class found inside the
`subscriber.py` (API) module implementation.  I think this particular
model is rather under-developed and currently not placed in the right
place (shouldn't be inside `subscriber.py` which should really just be
the controller definitions).  This module has a potential to be
leveraged more effectively if the goal is for this to become one the
the core CORD models from which other devices inherit from (which I'm
guessing it will be).

We will need to review its association with the `cord-subscriber`
model and better understand its role in relation with other *device*
oriented data models.

This module provides *export definitions* and does not contain any
configuration data tree.

### cord-subscriber

- YANG schema: [cord-subscriber.yang](./schema/cord-subscriber.yang)
- Source reference: [opencord/olt](http://github.com/opencord/olt)

This module contains the heart of the initial modeling exercise.  It
captures the CORD Subscriber data model (which extends XOS Subscriber
model, which extends XOS TenantRoot model).  There are two primary
models: `grouping subscriber` and `grouping subscriber-controller`.

This module provides *export definitions* and does not contain any
configuration data tree.

#### grouping subscriber

The 'subscriber' model extends the `xos:subscriber` (from the
[xos-core.yang](./xos-core.yang)) and mirrors as closely as possible
the `CordSubscriberRoot` class.  Some deviations were largely around
the variable name convention where I've replaced all underscore with a
dash (*upload_speed* is now *upload-speed*).  This is largely to
comply with YANG convention where the schema is used to model XML
element structure and underscores are not really used in XML based
representations (not even sure if it is valid...).

The other key deviation is in the organization of the various
attributes.  Instead of having a simple flat list of properties, I've
grouped them into related 'services' (pseudo-JSON below):

```js
services: {
  cdn: {
    enabled: true
  },
  firewall: {
    enabled: true,
    rules: []
  },
  url-filter: {
    enabled: true,
    level: 'PG',
    rules: []
  }
  uverse: {
    enabled: true
  }
}
```

Eventually, I think these four *hard-coded* services will be moved out
of the `cord-subscriber` data model altogether.  I'm not sure what
*on-boarded* services actually implement these features but it should
be augmented by those individual service's YANG models into the
cord-subscriber data model.

#### grouping subscriber-controller

I've internally debated creating this controller model because I
thought that the necessary attributes were rather effectively captured
in the prior `grouping subscriber` schema definition.  But the
presence of the `related` object container in the controller (that
shouldn't be in the underlying model) convinced me to model it
according to the `CordSubscriberNew` class found inside
`api/tenant/cord/subscriber.py`.  This `subscriber-controller` model
extends the `subscriber` model (inheriting all its attributes) and
introduces the additional containers for `features`, `identity`, and
`related`.  Since the main function of the `subscriber-controller`
model is to essentially layer a *view-like* overlay on top of the
underlying cord-subscriber model, I've introduced a new *custom
extension* construct called `node:link`.  This is to capture the fact
that the various attributes being expressed are simply a reference
link to the exact same data that is located at a different place
within the same object.

One note on the `related` object, it is currently a placeholder
container and I expect it will remain that way as part of the model.
The reason is, the attributes that are currently mapped inside all
come from the `VOLT` service (which then has other attributes from
`VSG` service, etc.).  When we get to the step of modeling the various
`Service` entities, we'll capture the necessary *augment* behavior in
those separate YANG modules (i.e. cord-service-volt.yang,
cord-service-vsg.yang, etc.).

