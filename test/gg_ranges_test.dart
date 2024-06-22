// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_list/src/gg_ranges.dart';
import 'package:test/test.dart';

void main() {
  group('GgRanges', () {
    group('isInRange', () {
      const iir = GgRanges.isInRange;
      group('unsigned', () {
        test('uint8', () {
          expect(
            iir(val: GgRanges.uint8Min - 1, bits: 8, isSigned: false),
            false,
          );
          expect(
            iir(val: GgRanges.uint8Min, bits: 8, isSigned: false),
            true,
          );
          expect(
            iir(val: GgRanges.uint8Max, bits: 8, isSigned: false),
            true,
          );
          expect(
            iir(val: GgRanges.uint8Max + 1, bits: 8, isSigned: false),
            false,
          );
        });

        test('uint16', () {
          expect(
            iir(val: GgRanges.uint16Min - 1, bits: 16, isSigned: false),
            false,
          );
          expect(
            iir(val: GgRanges.uint16Min, bits: 16, isSigned: false),
            true,
          );
          expect(
            iir(val: GgRanges.uint16Max, bits: 16, isSigned: false),
            true,
          );
          expect(
            iir(val: GgRanges.uint16Max + 1, bits: 16, isSigned: false),
            false,
          );
        });

        test('uint64', () {
          expect(
            iir(val: GgRanges.uint32Min - 1, bits: 32, isSigned: false),
            false,
          );
          expect(
            iir(val: GgRanges.uint32Min, bits: 32, isSigned: false),
            true,
          );
          expect(
            iir(val: GgRanges.uint32Max, bits: 32, isSigned: false),
            true,
          );
          expect(
            iir(val: GgRanges.uint32Max + 1, bits: 32, isSigned: false),
            false,
          );
        });

        test('uint64', () {
          expect(
            iir(val: GgRanges.uint64Min - 1, bits: 64, isSigned: false),
            false,
          );
          expect(
            iir(val: GgRanges.uint64Min, bits: 64, isSigned: false),
            true,
          );
          expect(
            iir(val: GgRanges.uint64Max, bits: 64, isSigned: false),
            true,
          );
          expect(
            iir(val: GgRanges.uint64Max + 1, bits: 64, isSigned: false),
            false,
          );
        });
      });

      group('signed', () {
        test('int8', () {
          expect(
            iir(val: GgRanges.int8Min - 1, bits: 8, isSigned: true),
            false,
          );
          expect(
            iir(val: GgRanges.int8Min, bits: 8, isSigned: true),
            true,
          );
          expect(
            iir(val: GgRanges.int8Max, bits: 8, isSigned: true),
            true,
          );
          expect(
            iir(val: GgRanges.int8Max + 1, bits: 8, isSigned: true),
            false,
          );
        });

        test('int16', () {
          expect(
            iir(val: GgRanges.int16Min - 1, bits: 16, isSigned: true),
            false,
          );
          expect(
            iir(val: GgRanges.int16Min, bits: 16, isSigned: true),
            true,
          );
          expect(
            iir(val: GgRanges.int16Max, bits: 16, isSigned: true),
            true,
          );
          expect(
            iir(val: GgRanges.int16Max + 1, bits: 16, isSigned: true),
            false,
          );
        });

        test('int64', () {
          expect(
            iir(val: GgRanges.int32Min - 1, bits: 32, isSigned: true),
            false,
          );
          expect(
            iir(val: GgRanges.int32Min, bits: 32, isSigned: true),
            true,
          );
          expect(
            iir(val: GgRanges.int32Max, bits: 32, isSigned: true),
            true,
          );
          expect(
            iir(val: GgRanges.int32Max + 1, bits: 32, isSigned: true),
            false,
          );
        });

        test('int64', () {
          expect(
            iir(val: GgRanges.int64Min - 1, bits: 64, isSigned: true),
            true, // Overflows
          );
          expect(
            iir(val: GgRanges.int64Min, bits: 64, isSigned: true),
            true,
          );
          expect(
            iir(val: GgRanges.int64Max, bits: 64, isSigned: true),
            true,
          );
          expect(
            iir(val: GgRanges.int64Max + 1, bits: 64, isSigned: true),
            true, // Overflows
          );
        });
      });
    });
    group('minInt', () {
      group('should throw', () {
        test('on invalid bits', () {
          expect(
            () => GgRanges.minInt(bits: 7, isSigned: false),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Invalid bits 7',
              ),
            ),
          );
        });
      });
    });

    group('maxInt', () {
      group('should throw', () {
        test('on invalid bits', () {
          expect(
            () => GgRanges.maxInt(bits: 7, isSigned: false),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Invalid bits 7',
              ),
            ),
          );
        });
      });
    });
  });
}
