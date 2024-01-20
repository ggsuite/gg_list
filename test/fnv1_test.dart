// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import 'package:gg_list/gg_list.dart';
import 'package:test/test.dart';

enum E { x, y, z }

// #############################################################################
void main() {
  group('fnv1(data, start, end)', () {
    // #########################################################################
    test('Should work fine for buffers with length devidable by 8', () {
      final buffer = Uint16List(8);
      final hash = fnv1(buffer);
      expect(hash, -8227345800955486059);
    });

    // #########################################################################
    test('Should work fine for buffers with length not devidable by 8', () {
      final buffer = Uint16List(7);
      final hash = fnv1(buffer);
      expect(hash, 3996532018526443330);
    });

    // #########################################################################
    test('Should work fine for strings', () {
      final buffer = ['a', 'b', 'c'];
      final hash = fnv1(buffer);
      expect(hash, 6619819810309098008);
    });

    // #########################################################################
    test('Should work for enums', () {
      final buffer = [E.x, E.y, E.z];
      final hash = fnv1(buffer);
      expect(hash, 2114034622316947657);
    });
  });
}
