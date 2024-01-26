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
        expect(ggRowList.data, [
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

        expect(rowList.data, [
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
  });
}
