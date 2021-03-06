title: Проектирование приложения
date: 2016-04-08 17:43:24
---
## Теория
В основу построения приложения для UnityBase положен принцип [предметно-ориентированного проектирования](https://ru.wikipedia.org/wiki/%D0%9F%D1%80%D0%BE%D0%B1%D0%BB%D0%B5%D0%BC%D0%BD%D0%BE-%D0%BE%D1%80%D0%B8%D0%B5%D0%BD%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D0%BE%D0%B5_%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5) **(DDD) ** - создание программных абстракций, которые _моделируют предметную область_ и включают в себя сложную бизнес-логику, устраняющую промежуток между реальными условиями области применения продукта и кодом.  DDD позволяет структурировать большой проект и унифицировать интерфейсы взаимодействия между частями системы, что существенно упрощает как разработку сложных приложений, так и их дальнейшее сопровождение.

## Модели (models)
В большинстве систем масштаба предприятия используются крупномасштабные зоны ответственности. В UnityBase этот уровень абстракции называется **моделями**. Например, учетная система крупной корпорации может иметь следующие модели: 

- "Безопасность"
- "Администрирование"
- "Организационная структура"
- "Общие справочники"
- "Биллинг"
- "Рассылка уведомления"
- "Интеграция с ERP"

При проектировании система ведения организационной структуры и система безопасности выделяются как совершенно разные вещи. Приложения, в которых при реализации не удаётся разделить и изолировать бизнес-логику в модели с четко ограниченной функциональностью, часто приобретают архитектурный стиль, который имеет красноречивое название «Большой ком грязи». UnityBase помогает предотвратить такой эффект, предлагая разработчикам структурировать сложную предметную область на модели.  

Стандартная поставка платформы включает в себя ряд общеупотребимых моделей:

|Код модели|Описание|
|----------|--------|
|UB | Общесистемная модель. Отвечает за генерацию БД|
|UBA | Администрирование. Ведение пользователей, ролей, прав доступа к методам сущностей и аудит безопасности|
|UBS | Сервисы. Аудит, отчеты, нумераторы, настройки, нотификации, пессимистические блокировки |
|UBM | Метаданные для клиента `adminUI` а именно рабочие столы, ярлыки, формы, ER диаграммы|
|UBQ | Очереди сообщений и статистика их работы|
|CDN | Общеупотребимые классификаторы|
|ORG | Организационная структура|
|UDISK | Файловое хранилище с поддержкой `WebDAV` |
|PDF | Генерация PDF|
|XLSX | Генерация XLSX (Excel)|

{% note info %}
В UnityBase модели представлены в виде папок на сервере. 
{% endnote %}

## Сущности (entity)
Модель состоит из набора  _сущностей_. Например, модель "Организационная структура" состоит из сущностей: "Организационная единица", "Организация", "Подразделение", "Сотрудник", "Назначение" и т.д. Проще всего о сущностях думать как о существительных. У сущности есть _индивидуальность_ - **набор атрибутов**. 

Например, для сущности "Сотрудник" стоит определить атрибуты:
 - "Фамилия"
 - "Имя"
 - "Отчество"
 - "Дата рождения"
а для сущности "Назначение":
- "Дата с"
- "Дата по"
- "Организационная единица"
- "Сотрудник"

{% note info %}
Описание сущности хранится в метафайле - `кодСущности.meta` в формате JSON и располагается в папке модели 
{% endnote %}

## Поведение
Каждая сущность обладает _поведением_ - набором методов. О _методах_ стоит думать как о глаголах. Например, сущность "Сотрудник" должна уметь:
 - _сохранить_ свои изменения
 - _удалить_ себя из списка
 - _создать_ шаблон для добавления нового сотрудника со значениями по умолчанию

У сущности "Организационная единица" дополнительно должен быть метод _расформировать_.   

{% note info %}
Методы сущности хранятся в JavaScript файле `кодСущности.js` рядом с метафайлом
{% endnote %}

Для методов сущности существует три области видимости, по аналогии с концепцией ООП:
- публичные (__public__) - доступные для вызова клиентами извне (с использованием API)
- защищенные (__protected__) - доступные для вызова из методов других сущностей, но недоступные извне
- приватные (__private__) - доступные для вызова только методам этой сущности

## Миксины (mixins)
Очевидно, что существует ряд общих _поведений_ у сущностей. Например, "Сотрудник" и "Назначение" должны уметь сохранятся в БД, желательно учитывать историю изменения, как фамилии сотрудника, так и периода назначения, обе сущности желательно не удалять напрямую, а лишь помечать на удаление. Также администратору системы нужно знать историю выполнения операций над сущностями - кто, когда, с какого рабочего места и что модифицировал/удалял/добавлял.

В UnityBase реализация методов, общих для множества сущностей вынесена в **[Миксины](https://en.wikipedia.org/wiki/Mixin)** (примеси). Например, миксин "mStorage" добавляет к любой сущности публичные методы:
 - `select` - загрузить из БД
 - `insert` - сохранить в  БД
 - `update` - обновить значение атрибутов в БД
 - `delete` - удалить экземпляр из БД
 - `addNew` - создать новый экземпляр со значениями по умолчанию
 
  
{% note info %}
Кроме ускорения процесса проектирования и разработки, применение технологии примесей обеспечивает **единообразие в подходах**, что в результате существенно влияет на совокупную стоимость владения ПО, как за счет сопровождаемости - любой член команды разработки может сопровождать код, написанный другими, так и за счет снижения требований к обучению.
{% endnote %}

Стандартная поставка платформы включает следующие миксины:

|Mixin|Short name| Description|
|---|---|----|
|mStorage| ORM| Добавляет сущности CRUID методы, обеспечивает функционал мягкого удаления и оптимистической блокировки|
|audit| Aудит уровня записи|Обеспечивает запись всех CRUID операций над сущностями в сущность аудита **ubs_audit**|
|rls|Безопасность уровня записей|RLS is a security feature which allows developers to give access to a sub-set of data in their entity to others|
|aclRls|Access Control List Row Level Security|Безопасность уровня записей на базе списков контроля доступа [Access Control List](https://en.wikipedia.org/wiki/Access_control_list)|
|als|Attribute Level Security|Безопасность уровня атрибутов. Позволяет определить перечень доступных на просмотр/редактирование атрибутов экземпляра сущности на основании текущего состояния и активного пользователя|
|dataHistory|Историчность записей|Обеспечивает ведение истории изменения атрибутов сущности|
|unity|Наследование|Эмулирует объектно-ориентированную концепцию "наследования" на реляционной СУБД|
|tree|Древовидные структуры|Позволяет хранить древовидные структуры в плоском представлении с построением хранимого пути|   
|fts|Полнотекстовое индексирование|Построение полнотекстовых индексов на базе значений из атрибутов сущности|
|softLock|пессимистические блокировки|Pessimistic Lock|
|clobTruncate|CLOB<->varchar|Обрезает большие текстовые поля|


{% note info %}
Начиная с версии UnityBase 2.0 разработчик может создавать собственные миксины.
{% endnote %}

## Метаданные
Совокупность всех сущностей, описанных в модели предметной области, является **метаданными**. Клиентские приложения могут использовать метаданные для автоматической генерации частей пользовательского интерфейса (так делает `adminUI`), генерации документации, построения ER диаграмм, генерации DML/DDL запросов для СУБД и т.д. 

Сервер приложений на основе метаданных обеспечивает доступ к методам сущностей  с использованием - **Server API**. Другими словами
{% note info %}
серверу достаточно метафайла сущности для генерации API взаимодействия с этой сущностью.
{% endnote %}

## Server API
Клиентские приложения (либо другие автоматизированные системы) взаимодействуют с сервером приложений UnityBase с использованием протокола [HTTP(S)](https://ru.wikipedia.org/wiki/HTTP). Реализация данного протокола присутствует для _любого_ современного языка программирования, что позволяет встраивать решения на базе платформы в произвольную IT инфраструктуру. 

Протокол HTTP определяет понятие URI — Uniform Resource Identifier. Это, например, адрес, который мы набираем в строке браузера для доступа к ресурсу. Адрес состоит из двух частей:
 - URL (Uniform Resource Locator) - адрес ресурса
 - URN (Unifrorm Resource Name) - имя ресурса на сервере
 
Например, URI для доступа к почтовому ящику GMail: https://mail.google.com/mail/u/0/#inbox
В этом примере:
 - адрес ресурса (URL): https://mail.google.com/
 - имя ресурса   (URN): mail/u/0/#inbox

### Точки доступа - endpoints
Существуют разные типы запросов, которые могут присылать клиенты, например:
 - запрос статического файла `site.css` или `myPicture.jpeg`
 - запрос динамического контента с использованием AJAX, например - перечень пользователей системы
 - запрос на аутентификацию пользователя и.т.д.

Очевидно, внутренняя реализация обработчиков для таких запросов должна отличатся, и сервер должен уметь определить, какого рода ресурс требуется клиенту. Для этого в сервере введено понятие **endpoint** - точка доступа со своим обработчиком. Точка доступа однозначно идентифицируется по имени - первой (до обратного слеша) частью URN.
Например, при запросе на адрес http://localhost/getAppInfo - `getAppInfo` - имя точки доступа.
При запросе на адрес http://localhost/models/UB/schemas/ubConfig.schema.json имя точки доступа - **models**. Прочие параметры могут быть интерпретированы обаботчиком точки доступа по своим собственным правилам.

Базовая поставка сервера включает следующие точки доступа:

|Endpoint name|Authorized?| Description|
|---|---|----|
|getAppInfo|  | Information about application configuration |
|initEncryption|+|Negotiation of the encryption key (Enterprise edition)|
|stat|+|Return application usage statistic|
|auth|-|Authentication|
|logout|+|Logout authorized user|
|timeStamp|-|Return a current server timestamp|
|getDomainInfo|+|Return JSON representation of application Domain (metadata). Actually a part of metadata accessible to the logged in user|
|runSQL|+|Execute SQL instruction passed in POST BODY. Accessible ONLY from the local IP address. Optionnaly can take CONNECTION=connectionName URL parameter|
|evaluateScript|+|Evaluate JS in server context.  Accessible ONLY from the local IP address. Either `GET /evaluateScript?script=....` or `POST /evaluateScript BODY=script`|
|getDocument|+|Retrieve a document content from blob store and send it to response|
|setDocument|+|Put a document content to a temporary blob store|
|setUserData|+|Accept POST request with BODY = JSON with custom user data, to store to `uba_user.uData`|
|ubql|+|Run a UBQL query. See below|
|rest|+|TODO|
|models| | Return a model-related static files. Accept HTTP GET and expect MODEL_NAME as first URI part - http://host:port/models/ModelName/..... and return a file from modelName `public` folder|
|statics|+|Default endpoint. Server execute this handler if URL do not match any of registered endpoints.Will return a static file from a folder, configured in `serverConfig.httpServer.inetPub` parameter.


{% note info %}
При необходимости низкоуровневого манипулирования контентом HTTP запроса/ответа можно добавить собственную точку доступа используя [App.registerEndpoint](/api/serverNew/App.html#.registerEndpoint). В большинстве случаев рекомендуется использовать существующие endpoint `UBQL` либо `rest`. 
{% endnote %}

### REST vs Endpoints
В современном мире доминируют два архитектурных стиля организации клиент-серверного взаимодействия поверх протокола HTTP: REST и _специализированные_ точки доступа (_endpoints_). С детальным обзором достоинств и недостатков обеих подходов можно ознакомится в [этой статье от авторов React](https://facebook.github.io/react/blog/2015/05/01/graphql-introduction.html#why-invent-something-new). Задолго до появления GraphQL мы столкнулись с похожими проблемами при имплементации протокола взаимодействия с сервером UB, и как решение был предложен протокол UnityBase Query Language (UBQL)
## UBQL

todo
## Безопасность
todo