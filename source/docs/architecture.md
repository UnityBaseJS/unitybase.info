title: Architecture
date: 2016-04-08 17:43:24
---
## Application server

UnityBase application server - **asynchronous** HTTP server with embadded **synchronous** multithread JavaScript runtime, ORM with transactional database support (Oracle, SQL Server, PostgreSQL) and stores for unsctructured content (files). Server functionality can be expanded with modules written in JavaScript or C/C++.
All server API is based on HTTP,allowing full-featured and seamlessly integrated of solution based on UnityBase with any other product that supports the HTTP protocol.

### Architecture
The diagram below shows a generalized architecture UB server: 

![](/images/ubServerArchitecture.png)

When running in a multithreaded mode, server picks up a pool of independent work thread, each of which contains its own copy of the JavaScript runtime with loaded business logic, and (if necessary) - a database connection.

When the client send an HTTP request, it is queued and transmitted to the first non-used thread. Thus UB server out of the box is a lightweight [FastCGI](https://ru.wikipedia.org/wiki/FastCGI) or [Node Cluster](https://nodejs.org/api/cluster.html).

Unlike Node JS JavaScript inside the UnityBase working thread are synchronous that dramatically simplifies writing server-side business logic. An unhandled exception inside the thread interrupt the current task, put thread in a "ready to use" state and send  exception text in the HTTP response queue. If successful, the result is also placed in the HTTP response queue.

HTTP queue operate in asynchronous non-blocking mode.

### Scale
#### Vertical 
Vertical scale - увеличение мощности сервера, осуществляется настройкой в конфигурационном файле количества рабочих потоков и длины очереди. При наличии достаточного количества ядер процессора не наблюдаеся деградации вплоть до 64х рабочих потоков. Длина очереди теоретически ограничена  размером ОЗУ. Таким образом при высокой нагрузке сервер UB способен эффективно (100%) использовать вычислительные мощности сервера вплоть до 64 ядерной конфигурации. 

Additional topic:
 - HTTP server configuration
 - Virtualization & HI Load

#### Horisontal
Horisontal scale - увеличение количества серверов.

Если возможностей вертикального масштабирования недостаточно, что бывает крайне редко и в большинстве случаев свидетельствует о неоптимальном проектировании серверной бизнес логики, можно применить горизонтальное масштабирование. При этом перед пулом серверов приложений устанавливается и конфигурируется баллансировщик нагрузки. Особенностью UB при горизонтальном масштабировании является хранение каждым екземпляром сервера пользовательский сессий. Для предотвращеня повторных запросов на авторизацию баллансировщик должен обеспечивать попадание всех запросов с одного и того же IP-адреса на один и тот же сервер из пула. 


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