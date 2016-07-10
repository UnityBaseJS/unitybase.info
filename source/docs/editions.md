title: Editions & License
date: 2016-05-04 17:00:00
---
# UnityBase editions

## Application server

### Standard edition
This edition if free for any kind of legal usage. 
Include:
 - PostgreSQl & sqlite3 database access
 - administrative (UBA) model
 - Schedullers (UBQ ) model
 - Common dictionary model (CDN)
 - Organization structure model (ORG)
 - `adminUI` (UBM) model

The latest version of Standard Edition can be [downloaded here](/downloads/UnityBaseSetup.exe)

### Enterprise edition
Commertial version. Additianaly include:
 - Oracle & MSSQL database access
 - OData module
 - PDFSign module
 - Model for PDF generation (PDF) and excel (XLSX)
 - WebDav model (WD)
 - Model for organize a shared folders with WebDav access (UDISK)
 - State machine (WF)

### Defense edition
This edition include all features from Enterprise + DSTU encription & signature algorithms.

## Clients
### adminUI
Admin UI licensed under GPL v3
adminUI - [Rich Internet application](https://en.wikipedia.org/wiki/Rich_Internet_application), designed to create a desktop-like user interface. 
All UI elements are based on Domain model and often automatically generated. 

Thus it's enough to define entity on the server side ("Customer", for example), and adminUI will automatically build a view layer for:
 - list view of customers, includion pagination, filtration, sorting, export etc.
 - single element view/edit form
 - reference field (combobox) and the master / detail relationship 
 - menus 
 
 The administrative interface includes a built-in form builder that allows you to customize the user form in an arbitrary manner.

For a commertial usage you need to buy a [Sencha ExtJS license](https://www.sencha.com/legal/)

### ub-core
Licenced under MIT / GPL.
Set of JavaScript classes to facilitate interaction with the server for browser clients.  
This library can be used to build a custom UI using any Web application framework, whether Angular, React, etc.

Additionally, we can provide client libraries for `.Net`, `PHP`, `VBA (excel)`, `iOS`, `Android`.
 
### portalUI
under development

