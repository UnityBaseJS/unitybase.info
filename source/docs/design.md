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
In addition to accelerating the design and development process, the use of mixin technology ensures **uniformity of approach**.
the result - a significant impact on the total cost of ownership, both due to maintainability - any member of the development team can follow code written by others, and by reducing training requirements
{% endnote %}

UnityBase Standard Edition includes the following mixins:

|Mixin|Short name| Description|
|---|---|
|mStorage| ORM| Adds a CRUID methods, soft delete & optimistic lock|
|audit| Audit tail| Record all CRUID operations to the **ubs_audit**|
|rls|Row Level Security|RLS is a security feature which allows developers to give access to a sub-set of data in their entity to others|
|aclRls|Access Control List Row Level Security|Row level security based on ACL [Access Control List](https://en.wikipedia.org/wiki/Access_control_list)|
|als|Attribute Level Security|Attribute level security. It allows you to define a list available for viewing / editing entity instance attributes based on the current status and active user|
|dataHistory|Record history|Record history|
|unity|Unity|Simulates object-oriented concept of "inheritance" in the RDBMS|
|tree|Tree structure|It allows you to store tree structures in a flat representation with the construction of the stored path|
|fts|Full Text Search|Construction of the full-text index based on the value of the entity attribute|
|softLock|Pessimistic Lock|Pessimistic Lock|
|clobTruncate|CLOB<->varchar|Truncate a big CLOB attribute to the smallest size|


{% note info %}
Starting from UnityBase 2.0 developer can create his own mixins.
{% endnote %}

## Metadata
The collection of all entities that are described in the domain model is **metadata**.
Client applications can use the metadata to automatically generate parts of the user interface (so does `adminUI`),
documentation generation, construction of ER diagrams, generate DML / DDL queries to the database, etc.

Based on the metadata application server provides access to entity methods. In other words
{% note info %}
to generate API for interacting with domain, entity metafile is enough
{% endnote %}

## Server API
Client applications (or other automated system) interact with UnityBase application server using a [HTTP(S)](https://ru.wikipedia.org/wiki/HTTP) protocol.
The implementation of HTTP protocol is present for _any_ modern programming language that allows to build solutions based on UnityBase into any IT infrastructure.

todo
## UBQL

todo
## Безопасность
todo