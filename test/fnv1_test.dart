// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import 'package:gg_list/gg_list.dart';
import 'package:test/test.dart';

enum E { x, y, z }

void main() {
  group('fnv1(data, start, end)', () {
    test('Should work fine for buffers with length devidable by 8', () {
      final buffer = Uint16List(8);
      final hash = fnv1(buffer);
      expect(hash, -8227627276586361153);
    });

    test('Should work fine for buffers with length not devidable by 8', () {
      final buffer = Uint16List(7);
      final hash = fnv1(buffer);
      expect(hash, 3996250538634052716);
    });

    test('Should work fine for strings', () {
      final buffer = ['a', 'b', 'c'];
      final hash = fnv1(buffer);
      expect(hash, 6619819810309098008);
    });

    test('Should work for enums', () {
      final buffer = [E.x, E.y, E.z];
      final hash = fnv1(buffer);
      expect(hash, 2114034622316947657);
    });

    group('should not create hash collisions for simple combinations', () {
      group('with keys having', () {
        test('one value', () {
          const min = -10000;
          const max = 10000;

          final existingHashes = <int>[];

          for (var i = min; i < max; i++) {
            final hash = fnv1([i]);
            expect(existingHashes.contains(hash), isFalse);
            existingHashes.add(hash);
          }
        });

        test('two values', () {
          const min = -1000;
          const max = 1000;

          final existingHashes = <int>[];

          for (var i = min; i < max; i++) {
            for (var j = min; j < max; j++) {
              final hash = fnv1([i, j]);
              final hashExists = existingHashes.contains(hash);
              expect(hashExists, isFalse);
            }
          }
        });

        test('three values', () {
          const min = -100;
          const max = 100;

          final existingHashes = <int>[];

          for (var i = min; i < max; i++) {
            for (var j = min; j < max; j++) {
              for (var k = min; j < max; j++) {
                final hash = fnv1([i, j, k]);
                final hashExists = existingHashes.contains(hash);
                expect(hashExists, isFalse);
              }
            }
          }
        });
      });
    });
  });
}
