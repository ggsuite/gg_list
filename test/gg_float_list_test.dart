// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import 'package:gg_list/gg_list.dart';
import 'package:test/test.dart';

void main() {
  group('GgFloatList', () {
    group('example', () {
      test('should provide a float 32 list', () {
        final ggFloatList = GgFloatList.example;
        expect(ggFloatList.data, isA<Float32List>());
        expect(ggFloatList.data, [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]);
      });
    });

    group('fromList(values, min, max, listType)', () {
      test('should create a GgFloatList from a List', () {
        final ggFloatList = GgFloatList.fromList(
          [0.0, 1.0, 2.0, 3.0, 4.0, 5.0],
          min: 0.0,
          max: 5.0,
          listType: Float64List,
        );
        expect(ggFloatList.data, isA<Float64List>());
        expect(ggFloatList.data, [0.0, 1.0, 2.0, 3.0, 4.0, 5.0]);
      });

      group('should throw', () {
        test('when any of the values exceeds min or max', () {
          expect(
            () => GgFloatList.fromList(
              [0.0, 1.0, 2.0, 3.0, 4.0, 6.0],
              min: 0.0,
              max: 5.0,
              listType: Float32List,
            ),
            throwsA(isA<RangeError>()),
          );
        });
      });
    });

    group('fromFloatList(floatList)', () {
      test('should take over data', () {
        final floatList = GgFloatList.fromList(
          [0.0, 1.0, 2.0, 3.0, 4.0, 5.0],
          min: 0.0,
          max: 5.0,
          listType: Float32List,
        );
        final copy = GgFloatList.fromFloatList(floatList);
        expect(copy.data, isA<Float32List>());
        expect(copy.data, same(floatList.data));
      });
    });

    group('generate(createValue, length, min, max, listType)', () {
      test('should create a GgFloatList from a generator', () {
        final ggFloatList = GgFloatList.generate(
          createValue: (i) => i.toDouble(),
          length: 5,
          min: 0.0,
          max: 5.0,
          listType: Float32List,
        );
        expect(ggFloatList.data, isA<Float32List>());
        expect(ggFloatList.data, [0.0, 1.0, 2.0, 3.0, 4.0]);
      });

      group('should throw', () {
        test('when any of the values exceeds min or max', () {
          expect(
            () => GgFloatList.generate(
              createValue: (i) => i.toDouble(),
              length: 5,
              min: 0.0,
              max: 3.0,
              listType: Float32List,
            ),
            throwsA(isA<RangeError>()),
          );
        });
      });
    });

    group('transform(i, val)', () {
      test('should turn the list into a new list', () {
        final ggFloatList = GgFloatList.generate(
          createValue: (i) => i.toDouble(),
          length: 5,
          min: 0.0,
          max: 30.0,
          listType: Float32List,
        );
        final transformedList = ggFloatList.transform(
          (i, val) => i * val + 10.0,
        );
        expect(transformedList, [10.0, 11.0, 14.0, 19.0, 26.0]);
      });
    });

    group('addOneByOne(i, val)', () {
      test('should add two lists', () {
        final a = GgFloatList.fromList(
          [0.0, 1.0, 2.0, 3.0],
          min: 0.0,
          max: 10.0,
          listType: Float32List,
        );
        final b = GgFloatList.fromList(
          [4.0, 5.0, 6.0, 7.0],
          min: 0.0,
          max: 10.0,
          listType: Float32List,
        );
        final c = a.addOneByOne(b);
        expect(c, [4.0, 6.0, 8.0, 10.0]);
      });
    });

    group('toString', () {
      test('should return a string', () {
        final ggFloatList = GgFloatList.fromList(
          [0.0, 1.0, 2.0, 3.0, 4.0, 5.0],
          min: 0.0,
          max: 5.0,
          listType: Float32List,
        );
        expect(ggFloatList.toString(), '0.0, 1.0, 2.0, 3.0, 4.0, 5.0');
      });
    });

    group('copyWithValue', () {
      test('should copy the list and replace a given value', () {
        final ggFloatList = GgFloatList.fromList(
          [0.0, 1.0, 2.0, 3.0, 4.0, 5.0],
          min: 0.0,
          max: 5.0,
          listType: Float32List,
        );
        final copy = ggFloatList.copyWithValue(2, 10.0);
        expect(copy, [0.0, 1.0, 10.0, 3.0, 4.0, 5.0]);
      });
    });

    group('subList', () {
      test('should create a sublist', () {
        final ggFloatList = GgFloatList.fromList(
          [0.0, 1.0, 2.0, 3.0, 4.0, 5.0],
          min: 0.0,
          max: 5.0,
          listType: Float32List,
        );
        final copy = ggFloatList.subList(2, 4);
        expect(copy, [2.0, 3.0]);
      });
    });
  });
}
