// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import 'package:gg_list/gg_list.dart';
import 'package:test/test.dart';

void main() {
  group('IntListFactory', () {
    // #########################################################################
    test('should allow to create native int lists depending on a value range',
        () {
      // Uint8List
      final uint8ListFactory = GgIntListFactory(min: 0, max: 128);
      expect(uint8ListFactory.type, Uint8List);
      final uint8ListBuffer = uint8ListFactory.createBuffer(3);
      expect(uint8ListBuffer, [0, 0, 0]);
      final uint8ListBuffer2 = Uint8List.fromList([0, 1, 2]);

      final uint8ListCopy = uint8ListFactory.copyBuffer(uint8ListBuffer2);
      expect(uint8ListCopy, [0, 1, 2]);

      final uint8SubList = uint8ListFactory.sublistView(uint8ListBuffer2, 1, 3);
      expect(uint8SubList, [1, 2]);

      // Uint16List
      final uint16ListFactory = GgIntListFactory(
        min: 0,
        max: 32767,
      );
      expect(uint16ListFactory.type, Uint16List);
      final uint16ListBuffer = uint16ListFactory.createBuffer(3);
      expect(uint16ListBuffer, [0, 0, 0]);
      final uint16ListBuffer2 = Uint16List.fromList([0, 1, 2]);

      final uint16ListCopy = uint16ListFactory.copyBuffer(uint16ListBuffer2);
      expect(uint16ListCopy, [0, 1, 2]);

      final uint16SubList =
          uint16ListFactory.sublistView(uint16ListBuffer2, 1, 3);
      expect(uint16SubList, [1, 2]);

      // Uint32List
      final uint32ListFactory = GgIntListFactory(
        min: 0,
        max: 2147483647,
      );
      expect(uint32ListFactory.type, Uint32List);
      final uint32ListBuffer = uint32ListFactory.createBuffer(3);
      expect(uint32ListBuffer, [0, 0, 0]);
      final uint32ListBuffer2 = Uint32List.fromList([0, 1, 2]);

      final uint32ListCopy = uint32ListFactory.copyBuffer(uint32ListBuffer2);
      expect(uint32ListCopy, [0, 1, 2]);

      final uint32SubList =
          uint32ListFactory.sublistView(uint32ListBuffer2, 1, 3);
      expect(uint32SubList, [1, 2]);

      // Int8List
      final int8ListFactory = GgIntListFactory(
        min: -128,
        max: 127,
      );
      expect(int8ListFactory.type, Int8List);
      final int8ListBuffer = int8ListFactory.createBuffer(3);
      expect(int8ListBuffer, [0, 0, 0]);
      final int8ListBuffer2 = Int8List.fromList([0, 1, 2]);

      final int8ListCopy = int8ListFactory.copyBuffer(int8ListBuffer2);
      expect(int8ListCopy, [0, 1, 2]);

      final int8SubList = int8ListFactory.sublistView(int8ListBuffer2, 1, 3);
      expect(int8SubList, [1, 2]);

      // Int16List
      final int16ListFactory = GgIntListFactory(
        min: -32768,
        max: 32767,
      );
      expect(int16ListFactory.type, Int16List);
      final int16ListBuffer = int16ListFactory.createBuffer(3);
      expect(int16ListBuffer, [0, 0, 0]);
      final int16ListBuffer2 = Int16List.fromList([0, 1, 2]);

      final int16ListCopy = int16ListFactory.copyBuffer(int16ListBuffer2);
      expect(int16ListCopy, [0, 1, 2]);

      final int16SubList = int16ListFactory.sublistView(int16ListBuffer2, 1, 3);
      expect(int16SubList, [1, 2]);

      // Int32List
      final int32ListFactory = GgIntListFactory(
        min: -2147483648,
        max: -2147483647,
      );
      expect(int32ListFactory.type, Int32List);
      final int32ListBuffer = int32ListFactory.createBuffer(3);
      expect(int32ListBuffer, [0, 0, 0]);
      final int32ListBuffer2 = Int32List.fromList([0, 1, 2]);

      final int32ListCopy = int32ListFactory.copyBuffer(int32ListBuffer2);
      expect(int32ListCopy, [0, 1, 2]);

      final int32SubList = int32ListFactory.sublistView(int32ListBuffer2, 1, 3);
      expect(int32SubList, [1, 2]);

      // Int64List
      final int64ListFactory = GgIntListFactory(
        min: -9223372036854775808,
        max: -9223372036854775807,
      );
      expect(int64ListFactory.type, Int64List);
      final int64ListBuffer = int64ListFactory.createBuffer(3);
      expect(int64ListBuffer, [0, 0, 0]);
      final int64ListBuffer2 = Int64List.fromList([0, 1, 2]);

      final int64ListCopy = int64ListFactory.copyBuffer(int64ListBuffer2);
      expect(int64ListCopy, [0, 1, 2]);

      final int64SubList = int64ListFactory.sublistView(int64ListBuffer2, 1, 3);
      expect(int64SubList, [1, 2]);
    });
  });
}
