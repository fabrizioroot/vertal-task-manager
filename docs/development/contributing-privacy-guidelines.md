# Contributing Privacy Guidelines

This document provides guidance for contributors who wish to preserve their privacy while contributing to this project. It outlines recommended tools, practices, and operational considerations intended to reduce unnecessary data exposure during development and contribution workflows.

This guide does not guarantee contributor privacy, nor does it attempt to define a universal threat model. Privacy requirements vary depending on individual circumstances, environments, and risk tolerance.

Contributors are responsible for evaluating whether the practices described in this document are appropriate for their own threat model and for adapting them as needed. This document may change over time as tools, workflows, and project requirements evolve.

## Technologies

In order to keep track of every technology used and whether or not they eventually change their privacy policies, this section will cover every third-party dependency that this software uses:


|Technology         |Purpose                     |Network Access   | Telemetry |Network Trigger             |Notes                                     |
|-------------------|----------------------------|-----------------|-----------|----------------------------|------------------------------------------|
|`Flutter`          |Cross Platform UI framework |Yes              |Yes        |N/A                         |Used purely for app logic                 |
|`Dart`             |Application Language        |No               |No         |N/A                         |                                          |
|`SQLite`           |Local Storage               |No               |No         |N/A                         |Encrypted; Source of truth                |
|`PostgreSQL`       |Optional Sync Backend       |Yes (self-hosted)|No         |N/A (responds to API only)  |Stores shared tasks; fully user-controlled|
|`Docker`           |Backend Deployment          |No (Runtime)     |No         |N/A (for the user)          |Used for reproducible self-hosting        |
|`Cryptography/auth`|Passwordless authentication |No               |No         |N/A                        |Private keys never leave the device       |

