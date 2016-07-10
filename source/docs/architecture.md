title: Architecture
date: 2016-04-08 17:43:24
---
## Application server

UnityBase application server - **asynchronous** HTTP server with embadded **synchronous** multithread JavaScript runtime, ORM with transactional database support (Oracle, SQL Server, PostgreSQL) and stores for unsctructured content (files). Server functionality can be expanded with modules written in JavaScript or C/C++.
All server API is based on HTTP,allowing full-featured and seamlessly integrated of solution based on UnityBase with any other product that supports the HTTP protocol.

### Architecture
The diagram below shows a generalized architecture UB server: 

![](/images/ubServerArchitectureWS.png)

When running in a multithreaded mode, server picks up a pool of independent HTTP workers (thread), each of which contains its own copy of the JavaScript runtime with loaded business logic, and (if necessary) - a database connection.

When the client send an HTTP request, it is queued and transmitted to the first non-used HTTP worker. Thus UB server out of the box is a lightweight [FastCGI](https://ru.wikipedia.org/wiki/FastCGI) or [Node Cluster](https://nodejs.org/api/cluster.html).

Unlike Node JS JavaScript inside the worker are synchronous that dramatically simplifies writing server-side business logic. An unhandled exception inside the thread interrupt the current task, put thread in a "ready to use" state and send  exception text in the HTTP response queue. If successful, the result is also placed in the HTTP response queue.

HTTP queue operate in asynchronous non-blocking mode.

### Scalability

#### Vertically
Scale vertically (or scale up/down) means to add resources to (or remove resources from) a single node in a system.
Implemented by setting in the configuration file the number of worker threads and queue length
In the presence of a sufficient number of processor cores, we observed no degradation up to the 64 worker threads.
Queue length is theoretically limited by the size of RAM. Thus high load UB server can efficiently (100%),
use the server with up to 32 VCPU.

Additional topic:
 - HTTP server configuration
 - Virtualization & HI Load

#### Horizontally
Scale horizontally (or scale out/in) means to add more nodes to (or remove nodes from) a system, such as adding a new computer to a distributed software application.
You need it **very rarely** - UnityBase is fast enough to operate on the single note with for almost any kind of real task.
But it is possible to put a load balancer before the UnityBase servers farm.
During the horizontal scaling UB store user sessions inside each instance of the server.
To prevent re-authorization requests balancer should ensure redirect all the queries of the same client IP-address to the same server in the pool.


## Client applications
### adminUI
Allow to very quickly create _intranet_ Web application with autogeneration/declarative description of UI.

adminUI - [Rich Internet application](https://en.wikipedia.org/wiki/Rich_Internet_application), designed to create a desktop-like user interface. All UI elements are based on Domain model and often automatically generated. Thus it's enough to define entity on the server side ("Customer", for example), and adminUI will automatically build a view layer for:

 - list view of customers, includion pagination, filtration, sorting, export etc.
 - single element view/edit form
 - reference field (combobox) and the master / detail relationship 
 - menus 
 
 The administrative interface includes a built-in form builder that allows you to customize the user form in an arbitrary manner.

### portalUI
Data access layer for  `adminUI` is based on the library `ub-core.js`  - set of classes to facilitate interaction with the server for browser clients.  This library can be used to build a custom UI using any Web application framework, whether Angular, React, etc.

Additionally, we provide client libraries for `.Net`, `PHP`, `VBA (excel)`, `iOS`, `Android`.