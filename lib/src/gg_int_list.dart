// @license
// Copyright (c) ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import '../gg_list.dart';

/// A list implementation that manages ints lists internally as native arrays
class GgIntList extends GgList<int> {
  // ...........................................................................
  /// An int list internally managed as native array
  const GgIntList({
    required super.data,
    required super.hashCode,
    required super.createData,
    required super.copyData,
    required super.createSubList,
    required this.min,
    required this.max,
  });

  // ...........................................................................
  /// The minimum allowed value
  final int min;

  /// The maximum allowed value
  final int max;

  // ...........................................................................
  /// Creates a GgIntList from a List
  factory GgIntList.fromList(
    List<int> values, {
    int? min,
    int? max,
    Type? listType,
  }) {
    final naf = GgIntListFactory(min: min, max: max, listType: listType);
    final length = values.length;
    final data = naf.createBuffer(length);
    final minVal = naf.min;
    final maxVal = naf.max;

    for (var i = 0; i < length; i++) {
      final val = values[i];
      if (val < minVal || val > maxVal) {
        throw RangeError('Val $val must be between $min and $max.');
      }
      data[i] = val;
    }

    return GgIntList._fromBuffer(data, naf);
  }

  // ...........................................................................
  /// Derived classes can use this constructor to initialize itself based on a
  /// GgIntList.
  GgIntList.fromIntList(GgIntList intList)
    : min = intList.min,
      max = intList.max,
      super(
        data: intList.data as List<int>,
        hashCode: intList.hashCode,
        createData: intList.createData,
        copyData: intList.copyData,
        createSubList: intList.createSubList,
      );

  // ...........................................................................
  /// Creates a GgIntList from a createValue method
  factory GgIntList.generate({
    required int Function(int i)? createValue,
    required int length,
    int? min,
    int? max,
    Type? listType,
  }) => GgIntList._generate(createValue, length, min, max, listType);

  // ...........................................................................
  @override
  GgIntList transform(int Function(int i, int val) transform) {
    final src = data as List<int>;
    final length = src.length;
    final result = createData(length);
    final minVal = min;
    final maxVal = max;

    for (var i = 0; i < length; i++) {
      final val = transform(i, src[i]);
      if (val < minVal || val > maxVal) {
        throw RangeError('Val $val must be between $minVal and $maxVal.');
      }
      result[i] = val;
    }

    return GgIntList(
      data: result,
      hashCode: fnv1(result, 0, length),
      createData: createData,
      copyData: copyData,
      createSubList: createSubList,
      min: minVal,
      max: maxVal,
    );
  }

  // ...........................................................................
  /// The plus operator adding the items of two lists together

  GgIntList addOneByOne(GgIntList other) =>
      transform((i, val) => val + other[i]);

  // ...........................................................................
  @override
  String toString() => join(', ');

  // ######################
  // Private
  // ######################

  // ...........................................................................
  factory GgIntList._generate(
    int Function(int i)? createValue,
    int length,
    int? min,
    int? max,
    Type? listType,
  ) {
    final naf = GgIntListFactory(min: min, max: max, listType: listType);
    final data = naf.createBuffer(length);

    if (createValue != null) {
      final minVal = naf.min;
      final maxVal = naf.max;
      for (var i = 0; i < length; i++) {
        final val = createValue(i);
        if (val < minVal || val > maxVal) {
          throw RangeError('Val $val must be between $min and $max.');
        }
        data[i] = val;
      }
    }

    return GgIntList._fromBuffer(data, naf);
  }

  // ...........................................................................
  factory GgIntList._fromBuffer(List<int> data, GgIntListFactory naf) =>
      GgIntList(
        data: data,
        hashCode: fnv1(data, 0, data.length),
        createData: naf.createBuffer,
        copyData: naf.copyBuffer,
        createSubList: (p0, [start = 0, end]) =>
            naf.sublistView(p0 as TypedData, start, end),
        min: naf.min,
        max: naf.max,
      );
}

// #############################################################################
/// An example GgIntList mainly for testing purposes
final exampleGgIntList = GgIntList.generate(
  createValue: (i) => i,
  length: 8,
  min: 0,
  max: 8,
);
