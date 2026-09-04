# Privacy

This app is 100% Free and Open Source Software, and it's built for privacy advocates. **The application is designed so that the developer DOESN'T receive user data from app usage**, and all tasks marked as private are designed to remain local to the device, and are not transmitted by the application.

The app uses third-party technologies for development and optional self-hosted backend functionality, such as PostgreSQL. **These technologies are configured by this project, to the extent reasonably possible and verifiable, to operate without telemetry, analytics, or unsolicited network access**, according to documented privacy guidelines and audit results. Some upstream tools enable convenience features (such as update checks or analytics) by default; **Vertal explicitly disables or avoids these behaviors as part of its privacy baseline**. Server data is fully controlled by the user.

Note: This document focuses on runtime privacy guarantees affecting end users and self-hosted operators.

## Our definition of privacy

For Vertal, "privacy" means autonomy.

A component is considered privacy-compliant only if it **avoids unsolicited network traffic unless explicitly initiated by a user action for a clearly defined purpose**.

This includes disabling:

- Automatic update checks
- Crash reporting
- Usage analytics
- Dynamic asset fetching (e.g. fonts, images, etc.)

It's also important to state that, even though open source software isn't privacy-compliant by default, it's the defacto format for the development tools in this project, since open source gives us a better capacity to audit and configure them so that they can be as privacy friendly as possible.

## Threat Model

In this section, we will cover the different threats that Vertal tries to protect the user against, and also the ones it cannot protect the user against.

* Vertal has the capacity to protect against:

- telemetry collection
- unsolicited outbound traffic
- third party tracking
- centralized analytics

**(*) Vertal protects against app level threats, not OS level threats.**

Vertal doesn't protect neither the user nor the operator against:

- malware
- compromised devices
- malicious operators
- insecure backups
- physical access attacks
- OS-level compromise
- network-based attacks


## Dependency list

In order to keep track of every technology used and whether or not they eventually change their privacy policies, this section will cover every third-party dependency that this software uses:


|Technology         |Purpose                     |Network Access   | Telemetry |Network Trigger             |Notes                                     |
|-------------------|----------------------------|-----------------|-----------|----------------------------|------------------------------------------|
|`Flutter`          |Cross Platform UI framework |No (Runtime)     |No         |N/A                         |Used purely for app logic                 |
|`Dart`             |Application Language        |No (Runtime)     |No         |N/A                         |                                          |
|`SQLite`           |Local Storage               |No               |No         |N/A                         |Encrypted; Source of truth                |
|`PostgreSQL`       |Optional Sync Backend       |Yes (self-hosted)|No         |N/A (responds to API only)  |Stores shared tasks; fully user-controlled|
|`Docker`           |Backend Deployment          |No (Runtime)     |No         |N/A (for the user)          |Used for reproducible self-hosting        |
|`Cryptography/auth`|Passwordless authentication |No               |No         |N/A                        |Private keys never leave the device       |


**Important Note**: *As the development progresses, more dependencies could be added to this list. In case that any of these tools changes its privacy policy, please open a ticket on the project's repository "issues" section.*

### Technology explanation

The following section will cover a brief explanation of every technology listed in the previous table and how each works, in order to provide information about whether or not the tool is privacy-compliant by default, and how we configure it to make it compliant.

#### Flutter

Flutter is an open source, application framework being used in order to generate the structure of the project. Even though for Developers it does have components that trigger telemetry and analytics by default, this isn't a risk for the user, since once packaged, it becomes part of a compiled artifact, and not a third-party service or running engine.

For the user, Flutter cannot simply initiate any sort of connection or collect user data by default.

If you are a contributing developer, please check the development and auditing manuals. But as a head start, we recommend disabling these as soon as you start using Dart and Flutter:

```bash
flutter config --no-analytics
dart --disable-analytics
```

#### Dart

Dart is an open source, client-optimized programming language developed and stewarded by Google. Its core libraries are open source too. It's the primary language being used in the project, in order to easily maintain it as a cross-platform tool.

Dart does not run as a background service, nor does it initiate network connections by default. It's not made in a way to emit network traffic independently of app code.

To answer it clearly: it cannot communicate with other services using the internet unless it's explicitly ordered to do so by the developer, and it's inspectable and auditable.

#### SQLite

"SQLite is an open source C-language library that implements a small, fast, self-contained, high-reliability, fully featured, SQL database engine." (Sqlite Official Project Description)

It lacks:

- Daemon processes directly running in the background
- The need of a connection with external servers

And it's a good fit because it can be combined with encryption layers at the application or platform level.

Being an embedded database engine technology makes it the perfect choice for this privacy-focused project.

#### PostgreSQL

PostgreSQL is an open source object-relational database system. This engine is used to store information. For this project, its purpose is to store tasks assigned in the self hosted, collaborative environment.

PostgreSQL does not include built-in telemetry, usage analytics, or "phone home" mechanisms by default. Within vertal, it is deployed as a self-hosted backend component that acts a passive listener tool, so it doesn't trigger network actions by itself, only listens for API calls. It's supposed to be executed with the provided docker configuration so that it avoids unexpected behavior. It will, however, save logs in the server in a way that gives the operator enough information about problems while running. Because it is a network-capable database, the privacy of its data depends on the server operator; by following good practices, the database should remain safe from intruders.

#### Docker

Docker is an open source containerization tool which purpose is to allow for easy software deployment on any machine. In this case, Docker's purpose is to facilitate deployment, by packaging the backend environment into reproducible containers to facilitate database deployment for the task sharing and sync features of the app; it's meant to be used by operators.

In the following project, Docker is only used for deploying the server image that the self-hosted server operator can later run on a machine for development or deployment.

Vertal provides an official backend image configured to operate without telemetry or unsolicited outbound network traffic at the application level.


Talking about the Docker engine itself (for operators):

**The Docker Engine does not violate contributor privacy by default.
Please note that the Docker engine IS NOT the same as Docker Desktop.**

*Important Note:* It's the user's responsibility to trust an operator's instance, because it could've been modified. The official Vertal backend image is within the project’s integrity guarantees, while its runtime environment remains operator-controlled.

#### Cryptography/Auth

Cryptography is used in this project as a supporting security mechanism to help protect user data and reduce reliance on centralized identity systems. It is not treated as a complete security solution by itself.

User data may be stored locally on the device (via SQLite) and, optionally, on a self-hosted server. While both storage locations are under user control, neither local storage nor self-hosting is inherently secure by default. Cryptography is therefore applied to reduce risk, not to eliminate it.

It is important to understand that cryptography minimizes exposure but does not guarantee absolute security. Private keys can be compromised through device compromise, malware, physical access, or improper handling. For this reason, users are responsible for keeping their devices and environments secure.

##### Purpose of cryptography in this project

In this project, cryptography is used to:

- Provide a local authentication mechanism

- Establish a key-based identity for optional synchronization

- Allow verification of authorship and ownership of shared data

- Avoid passwords entirely, reducing credential leakage risks

##### Authentication model

Authentication in this project does not rely on third-party identity providers (such as Google, Apple, or similar services), nor does it involve traditional username-and-password accounts.

Instead, identity is derived from locally generated cryptographic keys. These keys are created on the user’s device and never leave the device by default. Authentication is only performed when the user explicitly enables features that require it (such as synchronization or collaboration).

##### Tradeoffs and limitations

Because cryptographic identity is tied to a locally stored private key, loss of that key may result in irreversible loss of access to associated data. Changing devices, reinstalling the application, or losing backups can therefore lead to permanent data loss if no recovery mechanism is in place.

This tradeoff is a deliberate design consideration, prioritizing privacy and decentralization over convenience. Alternative workflows (such as opt-in key backup or multi-device access mechanisms) may be explored in the future, but no recovery guarantees are currently provided.

### Risks to avoid during development

Flutter contains functions that invoke libraries from Google's official servers (google_fonts packages). Using these packages are a threat to our privacy model, since they require to automatically fetch the packages over the internet. In order to avoid this, all fonts will be manually curated, downloaded and packaged within the app in order to avoid the need to establish a connection with Google's servers.

## Audit process

Early build branches might include testing versions for auditing purposes which are **NOT** recommended for end users, as they might contain tools that could make use of non-privacy friendly components. The results of these audits will reflect which tools are appropriate for release candidates, and under which configurations/conditions.

The conditions and steps that every audit process will need to follow might be added in another document, in order to give a clear set of tools and instructions for volunteers that want to contribute to the app's development.

## About this document

This document describes the privacy guarantees of the Vertal client. These guarantees apply to released versions of the application. Any change affecting these guarantees will be documented and reflected in the application version.

