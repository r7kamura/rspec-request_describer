# Changelog

## Unreleased

### Fixed

- Reduce some files from gem package.

## 0.5.0 - 2024-03-28

### Added

- Raise friendly error on incorrect `describe` usage.

## 0.4.0 - 2023-07-10

### Added

- Support HEAD HTTP method.

## 0.3.2 - 2020-02-15

### Removed

- Remove runtime gem dependency on actionpack.

## 0.3.1 - 2019-05-08

### Fixed

- Fix env calculation timing.

## 0.3.0 - 2019-05-05

### Added

- Support symbol keys in request headers.

## 0.2.2 - 2018-05-13

### Fixed

- Fix bug: Ignore case-sensitivity of HTTP headers.

## 0.2.1 - 2017-02-27

### Fixed

- Fix error from `#process`.

## 0.2.0 - 2017-02-27

### Added

- Support actionpack 5.1.0.

### Changed

- Declare runtime dependency on actionpack.

## 0.1.1 - 2016-05-15

### Fixed

- Prevent warning for Rails 5.

## 0.1.0 - 2015-10-09

### Changed

- Rename `method` with `http_method`.

## 0.0.9 - 2015-06-24

### Changed

- Ignore case-sensivity on Content-Type checking.

## 0.0.8 - 2015-05-20

### Changed

- Use more sophisticated method capture pattern.

## 0.0.7 - 2015-04-20

### Added

- Add `send_request` to explicitly call `subject`.

## 0.0.6 - 2015-02-12

### Fixed

- Allow any non-space characters in URL path.

## 0.0.5 - 2014-12-25

### Fixed

- Allow hyphen in path.

## 0.0.4 - 2014-12-18

### Added

- Define HTTPS as reserved header name.

## 0.0.3 - 2014-10-13

### Removed

- Remove dependency on ActiveSupport's `Object#in?`.

## 0.0.2 - 2014-09-25

### Added

- Support RSpec 3.

## 0.0.1 - 2014-08-29

### Added

- 1st Release.
