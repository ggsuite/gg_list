// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_list/gg_list.dart';
import 'package:test/test.dart';

void main() {
  final ggRowList = exampleGgIntRowList;

  group('GgIntRowList', () {
    // #########################################################################
    group('exampleGgIntRowList', () {
      test('should work fine', () {
        expect(ggRowList.data, [
          GgIntList.fromList([0, 1, 2], min: 0, max: 2),
          GgIntList.fromList([0, 1, 2], min: 0, max: 2),
          GgIntList.fromList([0, 1, 2], min: 0, max: 2),
          GgIntList.fromList([0, 1, 2], min: 0, max: 2),
        ]);
      });
    });

    // #########################################################################
    group('generat(numRows, createRow)', () {
      test('should work fine', () {
        final rowList = GgIntRowList.generate(
          numRows: 2,
          createRow: (i) {
            final row = GgIntList.generate(
              length: 2,
              min: 0,
              max: 4,
              createValue: (j) {
                return i + j;
              },
            );

            return row;
          },
        );

        expect(rowList.data, [
          GgIntList.fromList([0, 1], min: 0, max: 2),
          GgIntList.fromList([1, 2], min: 0, max: 2),
        ]);
      });
    });

    // #########################################################################
    group('toString()', () {
      test('should return the right string', () {
        expect(
          exampleGgIntRowList.toString(),
          '0, 1, 2 | 0, 1, 2 | 0, 1, 2 | 0, 1, 2',
        );
      });
    });
  });
}
