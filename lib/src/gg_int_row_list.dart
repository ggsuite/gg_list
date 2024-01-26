// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import '../gg_list.dart';

/// A list of rows
class GgIntRowList extends GgList<GgIntList> {
  // ...........................................................................
  /// Creates a list of a list of rows
  GgIntRowList.fromRows(super.rows) : super.fromGgList();

  // ...........................................................................
  /// Generate rows using a delegate
  factory GgIntRowList.generate({
    required int numRows,
    required GgIntList Function(int i) createRow,
  }) {
    final rows = <GgIntList>[];

    for (int i = 0; i < numRows; i++) {
      final row = createRow(i);
      rows.add(row);
    }

    final ggRows = GgList<GgIntList>.fromList(rows);
    return GgIntRowList.fromRows(ggRows);
  }

  // ...........................................................................
  @override
  String toString() => data.join(' | ');
}

// #############################################################################
/// Example  GgIntRowList with 4 rows and 3 columns
final exampleGgIntRowList = GgIntRowList.generate(
  numRows: 4,
  createRow: (i) {
    final row = GgIntList.generate(
      min: 0,
      max: 3,
      length: 3,
      createValue: (i) {
        return i;
      },
    );

    return row;
  },
);
