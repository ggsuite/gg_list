// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// ignore_for_file: dead_code

import 'dart:math';
import 'dart:typed_data';
import 'package:gg_list/gg_list.dart';
import 'package:test/test.dart';

void main() {
  const rowCount = 60;
  const colCount = 70;
  const maxX = colCount - 1;
  const maxY = rowCount - 1;
  const cellCount = rowCount * colCount;
  const maxIndex = cellCount - 1;

  group('Gg2dIntList', () {
    // #########################################################################

    void expectRange<T>({
      required int min,
      required int max,
    }) {
      int i = 0;
      final range = max - min + 1;
      final s = Gg2dIntList.generate(
        createValue: (a, b) => min + (i++ % range),
        min: min,
        max: max,
        rowCount: rowCount,
        colCount: colCount,
      );
      expect(s, isA<Gg2dIntList>());
      expect(s.data, isA<T>());
      expect(s.data[0], min);
      expect(s.data[5], min + 5);
      expect(s.data[maxIndex], min + maxIndex % range);
    }

    test('performance should be perfect', () {
      const performanceTest = false;

      if (performanceTest) {
        var empty = Gg2dIntList.generate(
          createValue: (a, b) => 0,
          min: 0,
          max: 255,
          rowCount: rowCount,
          colCount: colCount,
        );

        // ........................................................
        // Measure how many times hashes can be calculated within 1s
        var stopwatch = Stopwatch();

        for (var n = 0; n < 30; n++) {
          var j = 1000;

          stopwatch.start();
          while (j-- > 0) {
            // empty.data[j % empty.data.length];
            empty.copyWithValue(5, 10, Random(15).nextInt(255));
          }
          stopwatch.stop();
          print('A Duration: ${stopwatch.elapsedMicroseconds / 1000.0}');

          stopwatch.reset();

          j = 1000;
          stopwatch.start();
          while (j-- > 0) {
            j * 5 + 10 / 2 * 10;
          }
          stopwatch.stop();
          // print('B Duration: ${stopwatch.elapsedMicroseconds / 1000.0}\n\n');
          stopwatch.reset();
        }
      }
    });

    // #########################################################################
    group('Int Spaces', () {
      // #######################################################################
      group('generate', () {
        test(
            'should create Uint8List, Uint16List etc. dependent on min and '
            'max ', () {
          // Check uints
          expectRange<Uint8List>(min: 0, max: 0xFF);
          expectRange<Uint16List>(min: 0, max: 0xFF + 1);
          expectRange<Uint16List>(min: 0, max: 0xFFFF);
          expectRange<Uint32List>(min: 0, max: 0xFFFF + 1);
          expectRange<Uint32List>(min: 0, max: 0xFFFFFFFF);

          expectRange<Int8List>(min: -1, max: pow(2, 7).toInt() - 1);
          expectRange<Int16List>(min: -1, max: pow(2, 7).toInt());
          expectRange<Int16List>(min: -1, max: pow(2, 15).toInt() - 1);
          expectRange<Int32List>(min: -1, max: pow(2, 15).toInt());
          expectRange<Int32List>(min: -1, max: pow(2, 31).toInt() - 1);
          expectRange<Int64List>(min: -1, max: pow(2, 31).toInt());

          expectRange<Int8List>(min: -pow(2, 7).toInt(), max: 0);
          expectRange<Int16List>(min: -pow(2, 7).toInt() - 1, max: 0);
          expectRange<Int16List>(min: -pow(2, 15).toInt(), max: 0);
          expectRange<Int32List>(min: -pow(2, 15).toInt() - 1, max: 0);
          expectRange<Int32List>(min: -pow(2, 31).toInt(), max: 0);
          expectRange<Int64List>(min: -pow(2, 31).toInt() - 1, max: 0);
        });

        test('should throw if a value is out of range', () {
          const min = -20;
          const max = 20;

          // Is on upper bound -> no throw
          expect(
            () {
              Gg2dIntList.generate(
                createValue: (a, b) => max,
                min: min,
                max: max,
                rowCount: rowCount,
                colCount: colCount,
              );
            },
            isNot(throwsRangeError),
          );

          // Is on lower bound -> no throw
          expect(
            () {
              Gg2dIntList.generate(
                createValue: (a, b) => min,
                min: min,
                max: max,
                rowCount: rowCount,
                colCount: colCount,
              );
            },
            isNot(throwsRangeError),
          );

          // Exceeds uppber bound
          expect(
            () {
              Gg2dIntList.generate(
                createValue: (a, b) => max + 1,
                min: min,
                max: max,
                rowCount: rowCount,
                colCount: colCount,
              );
            },
            throwsRangeError,
          );

          // Exceeds lower bound
          expect(
            () {
              Gg2dIntList.generate(
                createValue: (a, b) => min - 1,
                min: min,
                max: max,
                rowCount: rowCount,
                colCount: colCount,
              );
            },
            throwsRangeError,
          );
        });

        test('should work fine', () {
          final before = Gg2dIntList.generate(
            createValue: (a, b) => a * b,
            min: 0,
            max: rowCount * colCount,
            rowCount: rowCount,
            colCount: colCount,
          );

          // Access some ab-values
          expect(before.value(0, 0), 0 * 0);
          expect(before.value(5, 5), 5 * 5);
          expect(before.value(maxX, maxY), maxX * maxY);

          // Access a row
          final row = before.row(0);
          expect(row[0], 0 * 0);
          expect(row[1], 1 * 0);
          expect(row[maxX], 71 * 0);

          // Access a col
          final col = before.col(10);
          expect(col[0], 10 * 0);
          expect(col[1], 10 * 1);
          expect(col[maxY], 590);

          // Change a value
          const cA = 34;
          const cB = 0;
          const iA = 34;
          const iB = 0;
          final after = before.copyWithValue(cA, cB, 123);
          expect(after.value(34, 0), 123);

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
          final reverted = after.copyWithValue(
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
    });

    // #########################################################################
    group('row(int b) should return the right row data', () {
      test('A first test in the group', () {
        final s = Gg2dIntList.generate(
          createValue: (a, b) {
            return a + b * 1000;
          },
          min: 0,
          max: 0xFFFFFFFF,
          rowCount: rowCount,
          colCount: colCount,
        );

        final row0 = s.row(0);
        expect(row0, isA<Uint32List>());
        expect(row0[0], 0);
        expect(row0[1], 1);
        expect(row0[maxX], maxX);
        expect(row0, hasLength(colCount));
      });
    });
  });
}
