<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v2.0.0](https://github.com/puppetlabs/puppetlabs-ruby_task_helper/tree/v2.0.0) - 2026-09-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-ruby_task_helper/compare/1.0.0...v2.0.0)

### Changed

- (BOLT-193): ruby_task_helper pdk update to puppet 9 [#26](https://github.com/puppetlabs/puppetlabs-ruby_task_helper/pull/26) ([gavindidrichsen](https://github.com/gavindidrichsen))

## Release 1.0.0

### Major changes

* Module upgraded to be Puppet 8 compatible

## Release 0.6.1

### Bug fixes

* Fix bug in task invocation for authors running bolt with a ruby 3 interpreter.

## Release 0.6.0

### New features

* Increase maximum Puppet version to Puppet 8, making the module usable with Puppet 7.

## Release 0.5.1

### New features

* Added a `debug` method to add debugging statements to the `details` field of a `TaskError`.

* Added a `debug_statements` method to retrieve the current list of debugging statements.

## Release 0.4.0

### Bug fixes

* Previously error hashes were not wrapped under an `_error` key causing bolt to ignore underlying error message. 
  Now error hashes are wrapped under the expected `_error` key.

## Release 0.3.0

### Bug fixes

* Previously only top level parameter keys were symbolized. Now nested keys are also symbolized.

## Release 0.2.0

### Bug fixes

* Helper files should go in the `files` directory of a module to prevent them from being added to the puppet 
  ruby loadpath or seen as tasks.

## Release 0.1.0

This is the initial release.
