title: Design
date: 2016-04-08 17:43:24
---
## Introduction
UnityBase applications are built on the principle of [Model-driven engineering](https://en.wikipedia.org/wiki/Model-driven_engineering) **(MDE) ** - a software development methodology which focuses on creating and exploiting domain models which are conceptual models of all the topics related to a specific problem. Hence it highlights and aims at abstract representations of the knowledge and activities that govern a particular application domain, rather than the computing (f.e. algorithmic) concepts.  

The MDE approach is meant to increase productivity by maximizing compatibility between systems (via reusing of standardized models), simplifying the process of design (via models of recurring design patterns in the application domain), and promoting communication between individuals and teams working on the system (via the standardization of the terminology and the best practices used in the application domain).

## Models
In most of enterprise systems the large-scale areas of responsibility are used. In UnityBase this level of abstraction is called **models**. For example, the accounting system of a large corporation may have the following models: 

- "Security"
- "Administration"
- "Organizational structure"
- "Common dictionaries"
- "Billing"
- "Notifications"
- "ERP integrations"

In process of design the system of organizational structure and security system stand out as different issues. The applications which were designed with no separation and isolation of business-logic in a model with distinctly limited functionality often acquire the archirectural style with telling name «The Big Ball of Mud». UnityBase helps to prevent such effect offering the developers to structure the complicated domain into the models.  

Platform includes a number of commonly used models:

|Model code|Description|
|----------|--------|
|UB | Common for all system. Responsible for database generation|
|UBA | Administration. Management of users, roles, access rights, security audit|
|UBS | Services. Modification audit, reports, numerators, settings, notifications, pessimistic lock |
|UBM | Metadata for a `adminUI`: form(view) definition, desktops & shotrcuts (routing), ER diagrams|
|UBQ | Task queue and task execution statistics|
|CDN | Common dictionaries|
|ORG | Organizational structure|
|UDISK | Blob (file) store with `WebDAV` support|
|PDF | PDF generation (both client & server side)|
|XLSX | XLSX (Excel) generation|

{% note info %}
In UnityBase models are represented as folders on the server 
{% endnote %}

## Entities
The model consists of a set of __entities__. For instance, the model "Organizational structure" consists of the following entities: "Organizational unit", "Organization", "Department", "Employee", "Staff" and so on. It's more simple to imagine the entities as the nouns. The entity possesses the _individuality_ - **the set of the attributes**. 

For example, the entity "Employee" requires to spot such attributes as:
 - "Surname"
 - "Name"
 - "Patronymic"
 - "Date of Birth"

while the "Staff" entity requires:
- "Date from"
- "Date to"
- "Organizational Unit"
- "Employee"

{% note info %}
Entity definition is stored in the JSON file named as `entityCode.meta` inside the model folder
{% endnote %}

## Behavior
Each entity has a _behavior_ - a set of methods. The _methods_ should be imagined as the verbs. For instance, "Employee" entity has to be able to:
 - _save_ its changes
 - _delete_ itself from the list
 - _create_ the template for adding new employee with default values

The entity "Organizational Unit" has to obtain the method  _disband_ additionally.   

{% note info %}
The entity methods are stored in JavaScript file `entityCode.js` in the same folder where the metafile is stored
{% endnote %}

There are three access modifiers for the entity methods, Для методов сущности существует три области видимости, in analogy with concept of OOP:
- __public__ - available for external API call 
- __protected__ - available for call from other entity methods yet not available for external API call
- __private__ - available only for the current entity methods 

## Mixins
Obviously, the entities have a number of common _behavior_. For example, "Employee" and "Staff" should be able to be saved in DB, desirably to consider the history of the changes such as employee's surname and the period of appointment, both entities are advisable not to be deleted directly, only marked for deleting. Also the system administrator has to know the history of performing the operations with entities - who, when, where from and what exactly modified/deleted/added.

In UnityBase implementation of the methods which are common for many entities are placed into **[Mixins](https://en.wikipedia.org/wiki/Mixin)**. For example, mixin "mStorage" will add to entity such methods:
 - `select` - load instances from DB
 - `insert` - save instance to DB
 - `update` - update values of instance attributes into DB
 - `delete` - delete instancefrom DB
 - `addNew` -create a new instance with default values
 
  
{% note info %}
Кроме ускорения процесса проектирования и разработки, применение технологии примесей обеспечивает **единообразие в подходах**, что в результате существенно влияет на совокупную стоимость владения ПО, как за счет сопровождаемости - любой член команды разработки может сопровождать код, написанный другими, так и за счет снижения требований к обучению.
{% endnote %}

Стандартная поставка платформы включает следующие миксины:

|Mixin|Short name| Description|
|---|---|
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
Starting from UnityBase 2.0 developer can create his own mixins.
{% endnote %}

## Metadata
Совокупность всех сущностей, описанных в модели предметной области, является **метаданными**. Клиентские приложения могут использовать метаданные для автоматической генерации частей пользовательского интерфейса (так делает `adminUI`), генерации документации, построения ER диаграмм, генерации DML/DDL запросов для СУБД и т.д. 

Сервер приложений на основе метаданных обеспечивает доступ к методам сущностей  с использованием - **Server API**. Другими словами
{% note info %}
серверу достаточно метафайла сущности для генерации API взаимодействия с этой сущностью.
{% endnote %}

## Server API
Клиентские приложения (либо другие автоматизированные системы) взаимодействуют с сервером приложений UnityBase с использованием протокола [HTTP(S)](https://ru.wikipedia.org/wiki/HTTP). Реализация данного протокола присутствует для _любого_ современного языка программирования, что позволяет встраивать решения на базе UnityBase в любую IT инфраструктуру. 

todo
## UBQL

todo
## Безопасность
todo