// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_list/gg_list.dart';
import 'package:test/test.dart';

void main() {
  group('GgList', () {
    // #########################################################################
    group('generate(length, createValue, fill)', () {
      test('should work fine', () {
        final list = GgList<int>.generate(
          length: 5,
          createValue: (i) => i,
          fill: 0,
        );

        expect(list.data, [0, 1, 2, 3, 4]);
      });
    });

    // #########################################################################
    group('fromList(values)', () {
      test('should work', () {
        final strList = GgList.fromList(['1', '2', '3']);
        expect(strList.data, ['1', '2', '3']);
      });
    });

    // #########################################################################
    group('fromGgList(values)', () {
      test('should work', () {
        final strList = GgList.fromList(['1', '2', '3']);
        final strList2 = GgList.fromGgList(strList);
        expect(strList2.data, ['1', '2', '3']);
      });
    });

    // #########################################################################
    group('transform(i,v)', () {
      test('Should create a new transformed list', () {
        // Create a list
        final list = GgList<int>.generate(
          fill: 0,
          createValue: (i) => i,
          length: 3,
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
    group('String lists', () {
      test('should work fine', () {
        const numRows = 50;
        final before = GgList<String>.generate(
          length: numRows,
          createValue: (i) => '$i',
          fill: '',
        );

        // Access some ab-values
        expect(before.value(0), '0');

        // Change a value
        const cB = 0;
        final after = before.setValue(cB, 'changed');
        expect(after.value(cB), 'changed');

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

      // #######################################################################
      group('subList(start, end)', () {
        test('should work for string lists', () {
          expect(exampleGgList.subList(2, 4), ['2', '3']);
        });
      });

      // #######################################################################
      test('operator[]', () {
        expect(exampleGgList[0], '0');
        expect(exampleGgList[5], '5');
      });
    });
  });
}
