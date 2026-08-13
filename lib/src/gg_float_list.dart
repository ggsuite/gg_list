// @license
// Copyright (c) ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import '../gg_list.dart';

/// A list implementation that manages ints lists internally as native arrays
class GgFloatList extends GgList<double> {
  // ...........................................................................
  /// An int list internally managed as native array
  const GgFloatList({
    required super.data,
    required super.hashCode,
    required super.createData,
    required super.copyData,
    required super.createSubList,
    this.min,
    this.max,
    required this.listType,
  }) : assert(listType == Float32List || listType == Float64List);

  // ...........................................................................
  /// The minimum allowed value
  final double? min;

  /// The maximum allowed value
  final double? max;

  /// The type of the list, e.g. Float32List, Float63List etc
  final Type listType;

  // ...........................................................................
  /// Creates a GgFloatList from a List
  factory GgFloatList.fromList(
    List<double> values, {
    double? min,
    double? max,
    required Type listType,
  }) {
    assert(listType == Float32List || listType == Float64List);

    final length = values.length;
    final data = listType == Float32List
        ? Float32List(length)
        : Float64List(length);

    if (min == null && max == null) {
      for (var i = 0; i < length; i++) {
        data[i] = values[i];
      }
    } else {
      for (var i = 0; i < length; i++) {
        final val = values[i];
        if ((min != null && val < min) || (max != null && val > max)) {
          throw RangeError('Val $val must be between $min and $max.');
        }
        data[i] = val;
      }
    }

    return GgFloatList._fromBuffer(data, min, max, listType);
  }

  // ...........................................................................
  /// Derived classes can use this constructor to initialize itself based on a
  /// GgFloatList.
  GgFloatList.fromFloatList(GgFloatList floatList)
    : min = floatList.min,
      max = floatList.max,
      listType = floatList.listType,
      super(
        data: floatList.data as List<double>,
        hashCode: floatList.hashCode,
        createData: floatList.createData,
        copyData: floatList.copyData,
        createSubList: floatList.createSubList,
      );

  // ...........................................................................
  /// Creates a GgFloatList from a createValue method
  factory GgFloatList.generate({
    required double Function(int i)? createValue,
    required int length,
    double? min,
    double? max,
    required Type listType,
  }) => GgFloatList._generate(createValue, length, min, max, listType);

  // ...........................................................................
  @override
  GgFloatList transform(double Function(int i, double val) transform) {
    final src = data as List<double>;
    final length = src.length;
    final result = createData(length);
    final minVal = min;
    final maxVal = max;

    if (minVal == null && maxVal == null) {
      for (var i = 0; i < length; i++) {
        result[i] = transform(i, src[i]);
      }
    } else {
      for (var i = 0; i < length; i++) {
        final val = transform(i, src[i]);
        final tooSmall = minVal != null && val < minVal;
        if (tooSmall || (maxVal != null && val > maxVal)) {
          throw RangeError('Val $val must be between $minVal and $maxVal.');
        }
        result[i] = val;
      }
    }

    return GgFloatList(
      data: result,
      hashCode: fnv1(result, 0, length),
      createData: createData,
      copyData: copyData,
      createSubList: createSubList,
      min: minVal,
      max: maxVal,
      listType: listType,
    );
  }

  // ...........................................................................
  /// The plus operator adding the items of two lists together

  GgFloatList addOneByOne(GgFloatList other) =>
      transform((i, val) => val + other[i]);

  // ...........................................................................
  @override
  String toString() => join(', ');

  // ...........................................................................
  /// An example GgFloatList mainly for testing purposes
  static final GgFloatList example = GgFloatList.generate(
    createValue: (i) => i.toDouble(),
    length: 8,
    min: 0,
    max: 8,
    listType: Float32List,
  );

  // ######################
  // Private
  // ######################

  // ...........................................................................
  factory GgFloatList._generate(
    double Function(int i)? createValue,
    int length,
    double? min,
    double? max,
    Type listType,
  ) {
    assert(listType == Float32List || listType == Float64List);

    final data = listType == Float32List
        ? Float32List(length)
        : Float64List(length);

    if (createValue != null) {
      if (min == null && max == null) {
        for (var i = 0; i < length; i++) {
          data[i] = createValue(i);
        }
      } else {
        for (var i = 0; i < length; i++) {
          final val = createValue(i);
          if ((min != null && val < min) || (max != null && val > max)) {
            throw RangeError('Val $val must be between $min and $max.');
          }
          data[i] = val;
        }
      }
    }

    return GgFloatList._fromBuffer(data, min, max, listType);
  }

  // ...........................................................................
  factory GgFloatList._fromBuffer(
    List<double> data,
    double? min,
    double? max,
    Type listType,
  ) {
    final isFloat32 = listType == Float32List;

    return GgFloatList(
      data: data,
      hashCode: fnv1(data, 0, data.length),
      createData: isFloat32 ? Float32List.new : Float64List.new,
      copyData: isFloat32 ? Float32List.fromList : Float64List.fromList,
      createSubList: isFloat32
          ? (p0, [start = 0, end]) =>
                Float32List.sublistView(p0 as TypedData, start, end)
          : (p0, [start = 0, end]) =>
                Float64List.sublistView(p0 as TypedData, start, end),
      min: min,
      max: max,
      listType: listType,
    );
  }
}
