# GgList - Automatically chose the right native list type

GgList allows to create optimized lists based on the value range.

## State

[![Dart Script Execution](https://github.com/inlavigo/gg_list/actions/workflows/check.yaml/badge.svg)](https://github.com/inlavigo/gg_list/actions/workflows/check.yaml)

## Classes

| Class            | Description                                    |
| :--------------- | :--------------------------------------------- |
| `GgList`         | Create lists of ordinary value types           |
| `Gg2dList`       | Access organize list items as rows and cols    |
| `GgIntList`      | Create `Uint8List` etc based on a value range  |
| `Gg2dIntList`    | Access organize list items as rows and cols    |
| `IntListFactory` | Create native typed lists based on value range |

## Features

- Generate a list of a given length and a given value range
- GgList will automatically choose the right native type, e.g. `Uint8List`
- The generated list is unmutable
- Use `copyWith()` or `transform()` to generate new changed lists.
- Also `hashcode` is calculated

## Usage

Please look into the tests to find various usage examples.

## Features and bugs

Please file feature requests and bugs at [GitHub](https://github.com/inlavigo/gg_list).
