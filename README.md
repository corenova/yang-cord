# yang-cord
YANG models for CORD

This is a work-in-progress effort to create YANG data models for the CORD project.

## xos-core.yang

This YANG module will be the primary YANG module that will house all XOS related models going forward.  The models for these came from `xos/core/models` directory in the XOS repository.  It will eventually house the `Service` class, the `Tenant` class, etc.  One notable convention here is the existence of the `/api/tenant/cord` and `/api/service` configuration tree inside this module.  In a sense, I'm considering this YANG module to be the **master** module that all other modules derive from and augments into this module.  You can see this *augment* behavior in the [cord-subscriber.yang](./cord-subscriber.yang) schema.

For now, I've captured the `TenantRoot` and `Subscriber` classes.

## cord-device.yang

I created this YANG module based on the `CordDevice` class found inside the `subscriber.py` (API) module implementation.  I think this particular model is rather under-developed, and not placed in the right place (shouldn't be inside subscriber.py which should really just be the controller definitions).  This module has a potential to be leveraged more effectively if the goal is for this to become one the the core CORD models from which other devices inherit from (which I'm guessing it will be).

## cord-subscriber.yang

This module contains the heart of the initial modeling exercise.  It captures the CORD Subscriber data model (which extends XOS Subscriber model, which extends XOS TenantRoot model).  There are two primary models: `grouping subscriber` and `grouping subscriber-controller`.

The 'subscriber' model extends the xos:subscriber (from the [xos-core.yang](./xos-core.yang)) and mirrors as closely as possible the `CordSubscriberRoot` class.  Some deviations were largely around the variable name convention where I've replaced all underscore with a dash (*upload_speed* is now *upload-speed*).  This is largely to comply with YANG convention where the schema is used to model XML element structure and underscores are not really used in XML based representations (not even sure if it is valid...).

The other key deviation is in the organization of the various attributes.  Instead of having a simple flat list of properties, I've grouped them into related 'services' (pseudo-JSON below):

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

Eventually, I think these four *hard-coded* services will be moved out of the `cord-subscriber` data model altogether.  I'm not sure what "on-boarded" services actually implement these features but it should be augmented by those individual service's YANG models into the cord-subscriber data model.

