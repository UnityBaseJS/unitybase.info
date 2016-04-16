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
Веб приложение с поддержкой автогенерации/декларативного описания интерфейса пользователя, позволяющее создавать _интранет_ приложения неограниченного уровня сложности.

Административный интерфейс (adminUI) - [Rich Internet application](https://en.wikipedia.org/wiki/Rich_Internet_application), предназначенное для создания десктоп-подобного интерфейса пользователя. Большинство интерфейсных элементов adminUI тесно интегрированны с моделью предметной области и являются автогенерируемыми. Таким образом достаточно описать на стороне сервера новую сущность системы (например, "Контрагент"), и adminUI автоматически обеспечивает основные операции с указанной сущностью:

 - просмотр списка, включая поиск, фильтрацию и.т.д.
 - форма для редактирования екземпляра
 - сложные ссылочные поля и отношения мастер/деталь
 - пользовательское меню 
 
 Административный интерфейс включает в себя встроенный построитель форм, позволяющий кастомизировать пользовательские формы произвольным образом

### portalUI
Data access layer for  `adminUI` построен на базе библитотеки доступа `ub-core.js`  - наборе классов, облегчающий взаимодействие с сервером для браузерных клиентов.  Данная библиотека может быть использована в любом другом веб приложении, основанном на любом фреймворке, будь то Angular, React и.т.д. 
Дополнительно предоставляются клиентские библиотеки для `.Net`, `PHP`, `VBA (excel)`, `iOS`, `Android`.