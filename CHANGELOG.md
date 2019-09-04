# Changelog

All notable changes to this project will be documented in this file.

## Release 0.4.0

**Bugfixes**

Previously error hashes were not wrapped under an `_error` key causing bolt to ignore underlying error message. Now error hashes are wrapped under the expected `_error` key.

## Release 0.3.0

**Bugfixes**

Previously only top level parameter keys were symbolized. Now nested keys are also symbolized.

## Release 0.2.0

**Bugfixes**

Helper files should go in the `files` directory of a module to prevent them from being added to the puppet ruby loadpath or seen as tasks.

## Release 0.1.0

**Features**

**Bugfixes**

**Known Issues**
