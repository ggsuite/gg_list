// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
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
    required this.min,
    required this.max,
    required this.listType,
  }) : assert(listType == Float32List || listType == Float64List);

  // ...........................................................................
  /// The minimum allowed value
  final double min;

  /// The maximum allowed value
  final double max;

  /// The type of the list, e.g. Float32List, Float63List etc
  final Type listType;

  // ...........................................................................
  /// Creates a GgFloatList from a List
  factory GgFloatList.fromList(
    List<double> values, {
    required double min,
    required double max,
    required Type listType,
  }) =>
      GgFloatList.generate(
        createValue: (i) => values[i],
        length: values.length,
        min: min,
        max: max,
        listType: listType,
      );

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
    required double min,
    required double max,
    required Type listType,
  }) =>
      GgFloatList._generate(createValue, length, min, max, listType);

  // ...........................................................................
  @override
  GgFloatList transform(double Function(int i, double val) transform) {
    return GgFloatList.generate(
      createValue: (i) => transform(i, value(i)),
      length: length,
      min: min,
      max: max,
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
    double min,
    double max,
    Type listType,
  ) {
    assert(listType == Float32List || listType == Float64List);

    final createBuffer =
        listType == Float32List ? Float32List.new : Float64List.new;

    final copyBuffer =
        listType == Float32List ? Float32List.fromList : Float64List.fromList;

    final subList = listType == Float32List
        ? Float32List.sublistView
        : Float64List.sublistView;

    // Generate the int list
    final result = GgList<double>.special(
      length: length,
      createBuffer: createBuffer,
      copyBuffer: copyBuffer,
      subList: (p0, [start = 0, end]) => subList(p0 as TypedData, start, end),
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

    return GgFloatList(
      data: result.data as List<double>,
      hashCode: result.hashCode,
      createData: result.createData,
      copyData: result.copyData,
      createSubList: result.createSubList,
      min: min,
      max: max,
      listType: listType,
    );
  }
}
