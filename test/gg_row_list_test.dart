// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_list/gg_list.dart';
import 'package:test/test.dart';

void main() {
  final ggRowList = exampleGgRowList;

  group('GgRowList', () {
    // #########################################################################
    group('exampleGgRowList', () {
      test('should work fine', () {
        expect(ggRowList, [
          GgList.fromList([0, 1, 2]),
          GgList.fromList([0, 1, 2]),
          GgList.fromList([0, 1, 2]),
          GgList.fromList([0, 1, 2]),
        ]);
      });
    });

    // #########################################################################
    group('generate(numRows, createRow)', () {
      test('should work fine', () {
        final rowList = GgRowList<String>.generate(
          numRows: 2,
          createRow: (i) {
            final row = GgList<String>.generate(
              length: 2,
              fill: '',
              createValue: (j) {
                return '$j-$i';
              },
            );

            return row;
          },
        );

        expect(rowList, [
          GgList.fromList(['0-0', '1-0']),
          GgList.fromList(['0-1', '1-1']),
        ]);
      });
    });

    // #########################################################################
    group('toString()', () {
      test('should return the right string', () {
        expect(
          exampleGgRowList.toString(),
          '0, 1, 2 | 0, 1, 2 | 0, 1, 2 | 0, 1, 2',
        );
      });
    });

    // #########################################################################
    group('hashCode', () {
      test('should return the right hashCode', () {});
    });

    // #########################################################################
    group('get(row, col)', () {
      test('should return the right value', () {
        expect(exampleGgRowList.get(0, 0), 0);
        expect(exampleGgRowList.get(0, 1), 1);
        expect(exampleGgRowList.get(0, 2), 2);
        expect(exampleGgRowList.get(1, 0), 0);
        expect(exampleGgRowList.get(1, 1), 1);
        expect(exampleGgRowList.get(1, 2), 2);
        expect(exampleGgRowList.get(2, 0), 0);
        expect(exampleGgRowList.get(2, 1), 1);
        expect(exampleGgRowList.get(2, 2), 2);
      });
    });

    // #########################################################################
    group('row(row)', () {
      test('should return the right row', () {
        expect(exampleGgRowList.row(0), [0, 1, 2]);
        expect(exampleGgRowList.row(1), [0, 1, 2]);
        expect(exampleGgRowList.row(2), [0, 1, 2]);
        expect(exampleGgRowList.row(3), [0, 1, 2]);
      });
    });
  });
}
