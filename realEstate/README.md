# Real Estate Dataset

## Intro

This is a project I had to develop as part of my IT course assessment. The scenario was based on a hypotetical real estate firm which would like to manage their sales office, properties, employees, and property owners in several states of Australia. 

## Preparation to create the relational database

Well, to begin with, I used MySQL as my SQL database system as well as phpMyAdmin to write and run queries.  
  
* The first thing was to create a entiry-relationship diagram of the database system, defining all entities, collumns, primary and foreign keys.
  
![ERD_V02](https://github.com/arthuroc21/sqlportfolio/assets/28913184/6adad71b-2927-47a7-a036-9c296c8b7155)

* The second thing was to create tables for each entity to identify which colummns would be null and if it was necessary to use the auto increment.

_office table:_
| Field Name | Data Type | Length | Null? | Primary Key? | Auto Increment? |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
| id | INT |  | No | Yes | Yes |
| office_name | VARCHAR | 50 | No | No | No |
| state | VARCHAR | 5 | No | No | No |

_employee table:_
| Field Name | Data Type | Length | Null? | Primary Key? | Auto Increment? |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
| id | INT |  | No | Yes | Yes |
| full_name | VARCHAR | 50 | No | No | No |
| office_name | VARCHAR | 50 | Yes | No | No |
| office_id | INT |  | Yes | No | No |

_property table:_
| Field Name | Data Type | Length | Null? | Primary Key? | Auto Increment? |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
| id | INT |  | No | Yes | Yes |
| property_name | VARCHAR | 50 | No | No | No |
| state | VARCHAR | 5 | No | No | No |
| cost | FLOAT |  | No | No | No |

_owners table:_
| Field Name | Data Type | Length | Null? | Primary Key? | Auto Increment? |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
| id | INT |  | No | Yes | Yes |
| full_name | VARCHAR | 50 | No | No | No |
| property_name | VARCHAR | 50 | No | No | No |
| percent_owned | FLOAT |  | No | No | No |
| property_id | INT |  | No | No | No |

_property_office table:_
| Field Name | Data Type | Length | Null? | Primary Key? | Auto Increment? |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
| id | INT |  | No | Yes | Yes |
| property_name | VARCHAR | 50 | No | No | No |
| office_name | VARCHAR | 50 | No | No | No |
| property_id | INT |  | No | No | No |
| office_id | INT |  | No | No | No |

_property_message table:_
| Field Name | Data Type | Length | Null? | Primary Key? | Auto Increment? |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
| id | INT |  | No | Yes | Yes |
| message_date | DATE |  | No | No | No |
| message_time | TIME |  | No | No | No |
| message_text | VARCHAR | 100 | No | No | No |

* After that, I used SQL commands to create, update and modify the tables. All the programming code is in the sql file uploaded in this folder! Let me know if you have any question, any suggestion! You can reach me through my social medias! Cheers! :)
