// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// ignore_for_file: dead_code

import 'package:gg_list/src/gg_2d_list.dart';
import 'package:test/test.dart';

void main() {
  group('Gg2dList', () {
    // #########################################################################
    const colCount = 7;
    const rowCount = 11;
    const maxX = colCount - 1;
    const maxY = rowCount - 1;

    // #########################################################################
    group('String spaces', () {
      test('should work fine', () {
        final before = Gg2dList.generate<String>(
          createValue: (col, row) => '$col, $row',
          fill: '',
          rowCount: rowCount,
          colCount: colCount,
        );

        // Access some ab-values
        expect(before.value(0, 0), '0, 0');
        expect(before.value(5, 5), '5, 5');
        expect(before.value(maxX, maxY), '$maxX, $maxY');

        // Access a row
        final row = before.row(0);
        expect(row[0], '0, 0');
        expect(row[1], '1, 0');
        expect(row[maxX], '$maxX, 0');

        // Access a col
        final col = before.col(2);
        expect(col[0], '2, 0');
        expect(col[1], '2, 1');
        expect(col[maxY], '2, $maxY');

        // Change a value
        const cA = 2;
        const cB = 0;
        const iA = 2;
        const iB = 0;
        final after = before.setValue(cA, cB, 'changed');
        expect(after.value(2, 0), 'changed');

        // Objects should not be equal
        expect(before, isNot(after));

        // Hashes should have changed
        expect(before.hashCode, isNot(after.hashCode));
        expect(before.colHashes, isNot(after.colHashes));
        expect(before.rowHashes, isNot(after.rowHashes));

        // Only affected col hashes should have changed
        for (int col = 0; col < before.colHashes.length; col++) {
          if (col == iA) {
            expect(before.colHashes[col], isNot(after.colHashes[col]));
          } else {
            expect(before.colHashes[col], after.colHashes[col]);
          }
        }

        // Only affected row hashes should have changed
        for (int row = 0; row < before.rowHashes.length; row++) {
          if (row == iB) {
            expect(before.rowHashes[row], isNot(after.rowHashes[row]));
          } else {
            expect(before.rowHashes[row], after.rowHashes[row]);
          }
        }

        // Revert Change
        final reverted = after.setValue(
          cA,
          cB,
          before.value(cA, cB),
        );

        // Hashes should also be reverted
        expect(reverted.hashCode, before.hashCode);
        expect(reverted.rowHashes, before.rowHashes);
        expect(reverted.colHashes, before.colHashes);

        // Objects should be equal again
        expect(reverted, before);
      });
    });

    // #########################################################################
    group('toString()', () {
      test('should return the right string', () {
        expect(exampleGg2dList.toString(), '0, 1, 1, 2, 2, 3');
      });
    });
  });
}
