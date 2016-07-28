title: UB 1.12 LTS is finally out
date: 2016-07-13 16:01:34
tags:
  - versions
categories:
  - news
---

UnityBase 1.12 with Long Term Support is finally out.
In this version, we separate a platform onto the three editions:
 - **Standard edition** is if free for any kind of legal usage and support PostgreSQL and/or SQLite3 as a database backend. The installation [can be downloaded here](/downloads/UnityBaseSetup.exe) (15 Mb)
 - **Enterprise edition** is a commercial version with MSSQL and/or Oracle support
 - **Defense edition** include all features from Enterprise + DSTU 4145 encryption & signature algorithms

More [details about editions is here](/docs/editions.html).

The major changes in UB 1.12:
- **embedded [SQLite3](https://www.sqlite.org/)** as a backend database (limited [DDLGenerator](/api/serverNew/module-cmd_generateDDL.html) support for alter table)
- **no more separate developer (UBD.exe) & production (UB.exe) builds**. To run UnityBase in developer mode (with JavaScript debugger and extended logging) use `-dev` switch or set an environment variable `SET UB_DEV=true`
- **no more debug build for a `adminUI`** (`WebDbg` folder and `index-dev.html`) - `ub-core.min.js`, `admin-ui.min.js` and `q-lodash-crypto.min.js` are builded with the source maps, so in browser developer console appears as a normal (not minimized) JavaScript
- Huge cleanup of server API - see the [server-side API documentation](/api/serverNew/)
- Endpoint `runList` is renamed to `ubql` (UnityBase Query Language). `runList` is deprecated
- If server run under Windows8+ it support a  **two-way Server<->Client communication via Web Sockets** - [details is here](/api/serverNew/tutorial-web_sockets.html)
- Added support for **[Asynchronous endpoints](/api/serverNew/tutorial-delayed_operations.html)**
- Schedulers mechanism are redesigned to use an async endpoint & cron syntax for a timetable. Scheduler definition now placed inside the model, so every model can define his own set of schedulers - see the [schedulers tutorial](/api/serverNew/tutorial-schedulers.html)

UnityBase 1.12 will be actively supported until the end of 2016. After this, only critical bugs will be fixed.

The next UnityBase version will be 4.0.0 (we switch to the [Semantic Versioning](http://semver.org/)). The most important upcoming changes are:
- Full native **ES6** support, including [Classes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes) & [import/export](https://developer.mozilla.org/en/docs/web/javascript/reference/statements/import)
- Remote Debugging via [Firefox developer tools](https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging)
- Remote Management UI for a server instances, including visual entity designer, WEB-based IDE, remote logging, server restart and so on
