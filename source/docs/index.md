title: Introduction
date: 2016-04-08 17:43:24
---
Welcome to the UnityBase documentation. If you encounter any problems when using UnityBase, have a look at the  [troubleshooting guide](troubleshooting.html), raise an issue on [GitHub](https://github.com/unitybasejs/unitybase/issues) or start a topic on the [Google Group](https://groups.google.com/group/unitybase).

## What is UnityBase?

UnityBase - platform for the rapid development of Hi-Load enterprise web applications. The strongest area of application is [Record Management Systems](https://en.wikipedia.org/wiki/Records_management) (RMS) and [Electronic Document and Records Management System](https://en.wikipedia.org/wiki/Electronic_document_and_records_management_system) (EDRMS).

The server part of the platform - a high-performance web server with built-in support for JavaScript, ORM for transactional databases and metadata about the domain. The client part - [RIA](https://en.wikipedia.org/wiki/Rich_Internet_application) with user interface autogeneration based on metadata.

Automatically generated server API? based on metadata and an HTTP-based protocol allows you to interact with the server from any modern applications. Using of JavaScript language on the both the server and the client side allows not only to make quick changes to the functionality, but and assures a business owner you have all the source code in an accessible form to change, which is important for long-term support or in case of change of service provider.

Applications developed using the platform are:

- **scalable** - can serve thousands of active users.
- **maintained** - supports QOS, performance monitoring, low level database and system calls audit
- **tested** - ready for CI including autotests
- **secured** - support strong authentication schemas, including SSO
- **predictable** - all data changes of all users are recorded to audit tables
- **database agnostic** - can be used with Oracle, PostgreSQL of MS SQL database
- **ready for scale** - divided into logical blocks (models), connected to the application "on the fly"

Every day, more than 50 000 people are using solutions based on platforms that:

- accessible on a 24/7/365
- server a terabyte databases
- provide access to tens of terabytes of unstructured documents (files)
- consist of several hundreds of entities and implementing thousands of functional requirements
  
## Where to begin?
Approaches to the development of a large project is often different from those suitable for medium and small applications. We recommend starting with a study of the [design](design.html), which describes the basic principles and approaches to building applications using the platform.

The [Setup](setup.html) will help with the installation and initial configuration of the platform, and the section [first application](getting_started.html) - with the creation of your first application on UnityBase.

The [Architecture](architecture.html) article describes the low-level principles of UnityBase application server, which can be useful when planning the deployment of Hi-Load projects.

## OpenSource stack
UnityBase project uses several OpenSource technologies, without which the realization of all that we have done, would have been impossible:

- [SpiderMonkey](https://developer.mozilla.org/ru/docs/SpiderMonkey) - JavaScript runtime
- [Synopse](http://synopse.info/fossil/wiki/Synopse+OpenSource) - SOA framework. We are a SpiderMonkey integration contributor