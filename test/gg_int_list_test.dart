// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:math';
import 'dart:typed_data';

import 'package:gg_list/src/gg_int_list.dart';
import 'package:test/test.dart';

void main() {
  const numRows = 55;
  const max = 25;

  group('GgIntlist', () {
    // #########################################################################

    void expectRange<T>({
      required int min,
      required int max,
    }) {
      final range = max - min + 1;
      final s = GgIntList.generate(
        length: numRows,
        createValue: (i) => min + (i++ % range),
        min: min,
        max: max,
      );
      expect(s, isA<GgIntList>());
      expect(s.data, isA<T>());
      expect(s.data[0], min);
      expect(s.data[5], min + 5);
      expect(s.data[53], min + 53 % range);
    }

    // #########################################################################
    group('Int lists', () {
      // #######################################################################
      group('generateIntList', () {
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
              GgIntList.generate(
                length: numRows,
                createValue: (i) => max,
                min: min,
                max: max,
              );
            },
            isNot(throwsRangeError),
          );

          // Is on lower bound -> no throw
          expect(
            () {
              GgIntList.generate(
                length: numRows,
                createValue: (i) => min,
                min: min,
                max: max,
              );
            },
            isNot(throwsRangeError),
          );

          // Exceeds uppber bound
          expect(
            () {
              GgIntList.generate(
                length: numRows,
                createValue: (i) => max + 1,
                min: min,
                max: max,
              );
            },
            throwsRangeError,
          );

          // Exceeds lower bound
          expect(
            () {
              GgIntList.generate(
                length: numRows,
                createValue: (i) => min - 1,
                min: min,
                max: max,
              );
            },
            throwsRangeError,
          );
        });

        test('should work fine', () {
          final before = GgIntList.generate(
            length: numRows,
            createValue: (i) => i,
            min: 0,
            max: numRows,
          );

          // Access some ab-values
          expect(before.value(0), 0);
          expect(before.value(5), 5);
          expect(before.value(max), max);

          // Change a value
          const cB = 3;
          final after = before.setValue(cB, cB * 2);
          expect(after.value(cB), cB * 2);

          // Objects should not be equal
          expect(before, isNot(after));

          // Hashes should have changed
          expect(before.hashCode, isNot(after.hashCode));

          // Revert Change
          final reverted = after.setValue(
            cB,
            before.value(cB),
          );

          // Hashes should also be reverted
          expect(reverted.hashCode, before.hashCode);

          // Objects should be equal again
          expect(reverted, before);
        });
      });

      // #######################################################################
      group('subList(start, end)', () {
        test('should work for int lists', () {
          expect(exampleGgIntList.subList(2, 4), [2, 3]);
        });
      });

      // #######################################################################
      group('fromList(values, min, max)', () {
        test('should create an list with values', () {
          final list = GgIntList.fromList([0, 1, 2, 3], min: 0, max: 10);

          expect(list.data, [0, 1, 2, 3]);
          expect(list.data, isA<Uint8List>());
        });
      });

      // #######################################################################
      group('fromIntList(values, min, max)', () {
        test('should create an list with values', () {
          final list = GgIntList.fromIntList(exampleGgIntList);

          expect(list.data, exampleGgIntList.data);
          expect(list.data, isA<Uint8List>());
        });
      });

      // #######################################################################
      test('operator[]', () {
        expect(exampleGgIntList[0], 0);
        expect(exampleGgIntList[5], 5);
      });
    });

    // #########################################################################
    group('transform(i,v)', () {
      test('Should create a new transformed list', () {
        // Create a list
        final list = GgIntList.generate(
          createValue: (i) => i,
          length: 3,
          min: 0,
          max: 1000,
        );
        expect(list.data, [0, 1, 2]);

        // Transform that list
        final transformedList = list.transform(
          (i, val) => i * val + 10,
        );
        expect(transformedList.data, [10, 11, 14]);
      });
    });

    // #########################################################################
    group('operator=', () {
      test('should add two arrays', () {
        final a = GgIntList.fromList([0, 1, 2], min: 0, max: 10);
        final b = GgIntList.fromList([4, 5, 6], min: 0, max: 10);
        final c = a + b;
        expect(c.data, [4, 6, 8]);
      });
    });

    // #######################################################################
    group('subList(start, end)', () {
      test('should work', () {
        expect(exampleGgIntList.subList(2, 4), [2, 3]);
      });
    });

    // #######################################################################
    test('operator[]', () {
      expect(exampleGgIntList[0], 0);
      expect(exampleGgIntList[5], 5);
    });

    // #########################################################################
    group('toString()', () {
      test('should crate the right string', () {
        expect(exampleGgIntList.toString(), '0, 1, 2, 3, 4, 5, 6, 7');
      });
    });
  });
}
