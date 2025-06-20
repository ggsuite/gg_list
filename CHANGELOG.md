# Changelog

## [2.0.2] - 2025-06-20

### Added

- Add an exception when GgList.fromList receives an empty list

## [2.0.1] - 2024-12-18

### Changed

- Changed hashing of typed data

## [2.0.0] - 2024-12-07

### Changed

- Changed fnv1 algorithm - No Int64Lists are generated anymore because it does not work on web

## [1.3.3] - 2024-12-07

### Changed

- Make ranges web compatible. Uint64 is 2^53 -1 now

## [1.3.2] - 2024-06-22

### Fixed

- Fix an small issue

## [1.3.1] - 2024-06-22

### Added

- Add GgRanges.minInt, maxInt, isInRange

### Changed

- Make min and max for float list optional
- Make min and max value optional for GgIntList. Allow to specify the type directly

## [1.3.0] - 2024-04-29

### Added

- Add GgFloatList

## [1.2.7] - 2024-04-26

### Fixed

- Fix an hash collision with small int arrays

## [1.2.6] - 2024-04-13

### Changed

- Adjusted version
- Remove pubspec.lock from committed files
- ignore pubspec lock

## [1.2.5] - 2024-04-13

### Changed

- ignore pubspec.lock

### Removed

- dependency to gg\_install\_gg, remove ./check script
- dependency pana

## [1.2.4] - 2024-04-09

### Removed

- 'Pipline: Disable cache'

## [1.2.3] - 2024-04-09

### Changed

- Rework changelog
- 'Github Actions Pipeline'
- 'Github Actions Pipeline: Add SDK file containing flutter into .github/workflows to make github installing flutter and not dart SDK'
- Prepare publish

## 1.2.2 - 2024-01-01

- Make `GgIntListFactory` public
- Add `GgRanges`

## 1.2.0 - 2024-01-01

- `GgList` implements `List`
- Add `GgRow`

## 1.1.1 - 2024-01-01

- Add `GgRowList`
- Add `toString`

## 1.0.3 - 2024-01-01

- Initial version.

[2.0.2]: https://github.com/inlavigo/gg_list/compare/2.0.1...2.0.2
[2.0.1]: https://github.com/inlavigo/gg_list/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/inlavigo/gg_list/compare/1.3.3...2.0.0
[1.3.3]: https://github.com/inlavigo/gg_list/compare/1.3.2...1.3.3
[1.3.2]: https://github.com/inlavigo/gg_list/compare/1.3.1...1.3.2
[1.3.1]: https://github.com/inlavigo/gg_list/compare/1.3.0...1.3.1
[1.3.0]: https://github.com/inlavigo/gg_list/compare/1.2.7...1.3.0
[1.2.7]: https://github.com/inlavigo/gg_list/compare/1.2.6...1.2.7
[1.2.6]: https://github.com/inlavigo/gg_list/compare/1.2.5...1.2.6
[1.2.5]: https://github.com/inlavigo/gg_list/compare/1.2.4...1.2.5
[1.2.4]: https://github.com/inlavigo/gg_list/compare/1.2.3...1.2.4
[1.2.3]: https://github.com/inlavigo/gg_list/compare/1.2.2...1.2.3
