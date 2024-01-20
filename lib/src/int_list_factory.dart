// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

/// Helps to create Uint8List, Int8List, Uint16List, Int16List, ... depending
/// on a given value range.
class IntListFactory {
  /// Creates a factory for lists with values between [min] and [max]
  IntListFactory({required int min, required int max})
      : type = _type(min: min, max: max);

  // ...........................................................................
  /// The type of the generated lists, e.g. Uint8List, Uint16List etc
  final Type type;

  // ...........................................................................
  /// Creates a native int list of length
  List<int> createBuffer(int length) => _createBuffer[type]!(length);

  // ...........................................................................
  /// Copies a native int list
  List<int> copyBuffer(List<int> buffer) => _copyBuffer[type]!(buffer);

  // ...........................................................................
  /// Creates a sublist view of a native int list
  List<int> sublistView(TypedData buffer, int start, int? end) =>
      _sublistView[type]!(buffer, start, end);

  // ...........................................................................
  // Ranges

  /// The minimum value for uint8
  static const uint8Min = 0;

  /// The minimum value for uint16
  static const uint16Min = 0;

  /// The minimum value for uint32
  static const uint32Min = 0;

  /// The minimum value for uint64
  static const uint64Min = 0;

  /// The minimum value for int8
  static const int8Min = -128;

  /// The minimum value for int16
  static const int16Min = -32768;

  /// The minimum value for int32
  static const int32Min = -2147483648;

  /// The minimum value for int64
  static const int64Min = -9223372036854775808;

  /// The maximum value for uint8
  static const uint8Max = 0xFF;

  /// The maximum value for uint16
  static const uint16Max = 0xFFFF;

  /// The maximum value for uint32
  static const uint32Max = 0xFFFFFFFF;

  /// The maximum value for int8
  static const int8Max = 127;

  /// The maximum value for int16
  static const int16Max = 32767;

  /// The maximum value for int32
  static const int32Max = 2147483647;

  /// The maximum value for int64
  static const int64Max = 9223372036854775807;

  // ######################
  // Private
  // ######################
  // ...........................................................................
  /// Returns the ideal typed list type for a given value range
  static Type _type({required int min, required int max}) {
    final type = switch ([min, max]) {
      // Uint
      [>= uint8Min, <= uint8Max] => Uint8List,
      [>= uint16Min, <= uint16Max] => Uint16List,
      [>= uint32Min, <= uint32Max] => Uint32List,

      // Int
      [>= int8Min, <= int8Max] => Int8List,
      [>= int16Min, <= int16Max] => Int16List,
      [>= int32Min, <= int32Max] => Int32List,
      _ => Int64List,
    };

    return type;
  }

  static const _createBuffer = {
    Uint8List: Uint8List.new,
    Uint16List: Uint16List.new,
    Uint32List: Uint32List.new,
    Uint64List: Uint64List.new,
    Int8List: Int8List.new,
    Int16List: Int16List.new,
    Int32List: Int32List.new,
    Int64List: Int64List.new,
  };
  static const _copyBuffer = {
    Uint8List: Uint8List.fromList,
    Uint16List: Uint16List.fromList,
    Uint32List: Uint32List.fromList,
    Uint64List: Uint64List.fromList,
    Int8List: Int8List.fromList,
    Int16List: Int16List.fromList,
    Int32List: Int32List.fromList,
    Int64List: Int64List.fromList,
  };

  static const _sublistView = {
    Uint8List: Uint8List.sublistView,
    Uint16List: Uint16List.sublistView,
    Uint32List: Uint32List.sublistView,
    Uint64List: Uint64List.sublistView,
    Int8List: Int8List.sublistView,
    Int16List: Int16List.sublistView,
    Int32List: Int32List.sublistView,
    Int64List: Int64List.sublistView,
  };
}
