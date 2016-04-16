title: Design
date: 2016-04-08 17:43:24
---
## Introduction
UnityBase applications are built on the principle of [Model-driven engineering](https://en.wikipedia.org/wiki/Model-driven_engineering) **(MDE) ** - a software development methodology which focuses on creating and exploiting domain models, which are conceptual models of all the topics related to a specific problem. Hence it highlights and aims at abstract representations of the knowledge and activities that govern a particular application domain, rather than the computing (f.e. algorithmic) concepts.  

The MDE approach is meant to increase productivity by maximizing compatibility between systems (via reuse of standardized models), simplifying the process of design (via models of recurring design patterns in the application domain), and promoting communication between individuals and teams working on the system (via a standardization of the terminology and the best practices used in the application domain).

## Models
In most enterprise systems using large-scale areas of responsibility. In UnityBase this level of abstraction called **models**. For example, the accounting system of a large corporation may have the following models: 

- "Security"
- "Administration"
- "Organizational structure"
- "Common dictionaries"
- "Billing"
- "Notifications"
- "ERP integrations"

При проектировании система ведения организационной структуры и система безопасности выделяются как совершенно разные вещи. Приложения, в которых при реализации не удаётся разделить и изолировать бизнес-логику в модели с четко ограниченной функциональностью, часто приобретают архитектурный стиль, который имеет красноречивое название «Большой ком грязи». UnityBase помогает предотвратить такой эффект, предлагая разработчикам структурировать сложную предметную область на модели.  

Platform includes a number of commonly used models:

|Код модели|Описание|
|----------|--------|
|UB | Common for all system. Responsible for database generation|
|UBA | Administration. Management of users, roles, access rights, securirt audit|
|UBS | Services. Modification audit, reports, numerators, settings, notifications, pessimistic lock |
|UBM | Metadata for a `adminUI`: form(view) definition, desktops & shotrcuts (routing), ER diagrams|
|UBQ | Task queue and task execution statistics|
|CDN | Common dictionaries|
|ORG | Organizational structure|
|UDISK | Blob (file) store with `WebDAV` support|
|PDF | PDF generation (both client & server side)|
|XLSX | XLSX (Excel) generation|

{% note info %}
In UnityBase model represented as folders on the server 
{% endnote %}

## Entities
The model consists of a set of __entities__. Например, модель "Организационная структура" состоит из сущностей: "Организационная единица", "Организация", "Подразделение", "Сотрудник", "Назначение" и т.д. Проще всего о сущностях думать как о существительных. У сущности есть _индивидуальность_ - **набор атрибутов**. 

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
Entity definition are stored in the JSON file named as `entityCode.meta` inside the model folder
{% endnote %}

## Behavior
Each entity has a _behavior_ - a set of methods. О _методах_ стоит думать как о глаголах. Например, сущность "Сотрудник" должна уметь:
 - _сохранить_ свои изменения
 - _удалить_ себя из списка
 - _создать_ шаблон для добавления нового сотрудника со значениями по умолчанию

У сущности "Организационная единица" дополнительно должен быть метод _расформировать_.   

{% note info %}
Методы сущности хранятся в JavaScript файле `кодСущности.js` рядом с метафайлом
{% endnote %}

Для методов сущности существует три области видимости, по аналогии с концепцией ООП:
- __public__ - доступные для вызова клиентами извне (с использованием API)
- __protected__ - доступные для вызова из методов других сущностей, но недоступные извне
- __private__ - доступные для вызова только методам этой сущности

## Mixins
Очевидно, что существует ряд общих _поведений_ у сущностей. Например, "Сотрудник" и "Назначение" должны уметь сохранятся в БД, желательно учитывать историю изменения, как фамилии сотрудника, так и периода назначения, обе сущности желательно не удалять напрямую, а лишь помечать на удаление. Также администратору системы нужно знать историю выполнения операций над сущностями - кто, когда, с какого рабочего места и что модифицировал/удалял/добавлял.

В UnityBase реализация методов, общих для множества сущностей вынесена в **[Миксины](https://en.wikipedia.org/wiki/Mixin)**. Например, миксин "mStorage" добавляет к любой сущности публичные методы:
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
Начиная с версии UnityBase 2.0 разработчик может создавать собственные миксины.
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