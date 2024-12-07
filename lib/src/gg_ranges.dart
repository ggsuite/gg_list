// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

/// Offers ranges for uint8, uint16, uint32, uint64, int8, int16, int32, int64
class GgRanges {
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

  /// The minimum value for uint64
  static const uint64Max = int64Max;

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

  /// The maximum value for int64 (web save)
  static const int64Max = 9007199254740991;

  // ...........................................................................
  /// Returns the minimum value for the given number of bits
  static int minInt({required int bits, required bool isSigned}) {
    return switch (bits) {
      8 => isSigned ? int8Min : uint8Min,
      16 => isSigned ? int16Min : uint16Min,
      32 => isSigned ? int32Min : uint32Min,
      53 => isSigned
          ? int64Min // Web compatible https://developer.mozilla.org/de/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
          : uint64Min,
      64 => isSigned ? int64Min : uint64Min,
      _ => throw ArgumentError('Invalid bits $bits'),
    };
  }

  /// Returns the maximum value for the given number of bits
  static int maxInt({required int bits, required bool isSigned}) {
    return switch (bits) {
      8 => isSigned ? int8Max : uint8Max,
      16 => isSigned ? int16Max : uint16Max,
      32 => isSigned ? int32Max : uint32Max,
      53 => isSigned ? int64Max : uint64Max,
      64 => isSigned
          ? int64Max // Web compatible https://developer.mozilla.org/de/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
          : uint64Max,
      _ => throw ArgumentError('Invalid bits $bits'),
    };
  }

  /// Returns the number of bits for the given list type
  static int bitsForType(Type listType) {
    return switch (listType) {
      const (Uint8List) => 8,
      const (Uint16List) => 16,
      const (Uint32List) => 32,
      const (Uint64List) => 64,
      const (Int8List) => 8,
      const (Int16List) => 16,
      const (Int32List) => 32,
      const (Int64List) => 64,
      _ => throw ArgumentError('Invalid listType $listType'),
    };
  }

  /// Returns the number of bits for the given list type
  static bool isSigned(Type listType) {
    return switch (listType) {
      const (Uint8List) => false,
      const (Uint16List) => false,
      const (Uint32List) => false,
      const (Uint64List) => false,
      const (Int8List) => true,
      const (Int16List) => true,
      const (Int32List) => true,
      const (Int64List) => true,
      _ => throw ArgumentError('Invalid listType $listType'),
    };
  }

  // ...........................................................................
  /// Returns true if the value is in the range of the given number of bits
  static bool isInRange({
    required int val,
    required int bits,
    required bool isSigned,
  }) {
    final min = minInt(bits: bits, isSigned: isSigned);
    final max = maxInt(bits: bits, isSigned: isSigned);

    if (val < min || val > max) {
      return false;
    }
    return true;
  }
}
