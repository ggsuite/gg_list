// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import '../gg_list.dart';

/// A row of values
typedef GgRow<T> = GgList<T>;

/// A list of rows
class GgRowList<T> extends GgList<GgRow<T>> {
  // ...........................................................................
  /// Creates a list of a list of rows
  GgRowList.fromRows(super.rows) : super.fromGgList();

  // ...........................................................................
  /// Generate rows using a delegate
  factory GgRowList.generate({
    required int numRows,
    required GgRow<T> Function(int i) createRow,
  }) {
    final rows = <GgRow<T>>[];

    for (int i = 0; i < numRows; i++) {
      final row = createRow(i);
      rows.add(row);
    }

    final ggRows = GgList<GgRow<T>>.fromList(rows);
    return GgRowList.fromRows(ggRows);
  }

  // ...........................................................................
  /// Returns the value of a given cell
  T get(int row, int col) => this[row][col];

  /// Returns a given row
  GgRow<T> row(int row) => this[row];

  // ...........................................................................
  @override
  String toString() => join(' | ');
}

// #############################################################################
/// Example  GgRowList with 4 rows and 3 columns
final exampleGgRowList = GgRowList<int>.generate(
  numRows: 4,
  createRow: (i) {
    final row = GgList.generate(
      length: 3,
      fill: 0,
      createValue: (i) {
        return i;
      },
    );

    return row;
  },
);
