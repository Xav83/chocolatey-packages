# Security policy

## Scope

This repository contains the sources of Chocolatey community packages: nuspecs, install and uninstall scripts, AU update scripts, and the CI that builds and publishes them.

Please report here security problems in **the packages themselves**, for example:

* a package downloading its installer from an untrusted, hijacked or non-official location;
* a wrong or missing checksum, or a checksum that does not match the official file;
* an install or uninstall script doing something unsafe (running untrusted code, weakening permissions, leaving credentials behind...);
* a problem in the CI workflows or scripts of this repository that could let someone publish a modified package.

Vulnerabilities in **the software installed by a package** (for example a security flaw in the application itself) should be reported to its authors, using the project link on the package page. Problems with Chocolatey itself or with the community repository should be reported to [Chocolatey](https://docs.chocolatey.org/en-us/information/security).

## Reporting a vulnerability

Please **do not open a public issue** for a security problem.

Report it privately through GitHub instead: on the repository's [Security tab](https://github.com/Xav83/chocolatey-packages/security), choose **Report a vulnerability**. Include:

* the package (or the file of this repository) concerned, and its version;
* what is wrong, and how to reproduce or verify it;
* if possible, the official source you compared against (download page, published checksums...).

You should get an answer within a week. Depending on the problem, the fix is a new version of the package, a package version unlisted from the community repository, or a change in this repository. Reports are credited in the fix if you wish.
