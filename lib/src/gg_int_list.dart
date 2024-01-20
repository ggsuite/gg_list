// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import 'gg_list.dart';
import 'int_list_factory.dart';

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
    required int min,
    required int max,
  }) =>
      GgIntList.generate(
        createValue: (i) => values[i],
        length: values.length,
        min: min,
        max: max,
      );

  // ...........................................................................
  /// Derived classes can use this constructor to initialize itself based on a
  /// GgIntList.
  GgIntList.fromIntList(GgIntList intList)
      : min = intList.min,
        max = intList.max,
        super(
          data: intList.data,
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
    required int min,
    required int max,
  }) =>
      GgIntList._generate(createValue, length, min, max);

  // ...........................................................................
  @override
  GgIntList transform(int Function(int i, int val) transform) {
    return GgIntList.generate(
      createValue: (i) => transform(i, value(i)),
      length: data.length,
      min: min,
      max: max,
    );
  }

  // ...........................................................................
  /// The plus operator adding the items of two lists together
  GgIntList operator +(GgIntList other) =>
      transform((i, val) => val + other.data[i]);

  // ######################
  // Private
  // ######################

  // ...........................................................................
  factory GgIntList._generate(
    int Function(int i)? createValue,
    int length,
    int min,
    int max,
  ) {
    final naf = IntListFactory(min: min, max: max);

    // Generate the int list
    final result = GgList<int>.special(
      length: length,
      createBuffer: naf.createBuffer,
      copyBuffer: naf.copyBuffer,
      subList: (p0, [start = 0, end]) =>
          naf.sublistView(p0 as TypedData, start, end),
      createValue: createValue == null
          ? null
          : (i) {
              final val = createValue(i);
              if (val < min || val > max) {
                throw RangeError('Val $val must be between $min and $max.');
              }
              return val;
            },
    );

    return GgIntList(
      data: result.data,
      hashCode: result.hashCode,
      createData: result.createData,
      copyData: result.copyData,
      createSubList: result.createSubList,
      min: min,
      max: max,
    );
  }
}

// #############################################################################
/// An example GgIntList mainly for testing purposes
final exampleGgIntList = GgIntList.generate(
  createValue: (i) => i,
  length: 8,
  min: 0,
  max: 8,
);
