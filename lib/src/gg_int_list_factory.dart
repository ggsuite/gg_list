// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import '../gg_list.dart';

/// Helps to create Uint8List, Int8List, Uint16List, Int16List, ... depending
/// on a given value range.
class GgIntListFactory {
  /// Creates a factory for lists with values between [min] and [max]
  GgIntListFactory({required int min, required int max})
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

  // ######################
  // Private
  // ######################
  // ...........................................................................
  /// Returns the ideal typed list type for a given value range
  static Type _type({required int min, required int max}) {
    final type = switch ([min, max]) {
      // Uint
      [>= GgRanges.uint8Min, <= GgRanges.uint8Max] => Uint8List,
      [>= GgRanges.uint16Min, <= GgRanges.uint16Max] => Uint16List,
      [>= GgRanges.uint32Min, <= GgRanges.uint32Max] => Uint32List,

      // Int
      [>= GgRanges.int8Min, <= GgRanges.int8Max] => Int8List,
      [>= GgRanges.int16Min, <= GgRanges.int16Max] => Int16List,
      [>= GgRanges.int32Min, <= GgRanges.int32Max] => Int32List,
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
