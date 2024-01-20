// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import 'gg_list.dart';
import 'int_list_factory.dart';

class GgIntlist extends GgList<int> {
  // ...........................................................................
  const GgIntlist({
    required super.data,
    required super.hashCode,
    required super.createBuffer,
    required super.copyBuffer,
    required super.createSubList,
    required this.min,
    required this.max,
  });

  // ...........................................................................
  final int min;
  final int max;

  // ...........................................................................
  GgIntlist.fromIntList(GgIntlist intList)
      : min = intList.min,
        max = intList.max,
        super(
          data: intList.data,
          hashCode: intList.hashCode,
          createBuffer: intList.createBuffer,
          copyBuffer: intList.copyBuffer,
          createSubList: intList.createSubList,
        );

  // ...........................................................................
  factory GgIntlist.fromList(
    List<int> values, {
    required int min,
    required int max,
  }) =>
      GgIntlist.generate(
        createValue: (i) => values[i],
        length: values.length,
        min: min,
        max: max,
      );

  // ...........................................................................
  factory GgIntlist.generate({
    required int Function(int i)? createValue,
    required int length,
    required int min,
    required int max,
  }) =>
      GgIntlist._generate(createValue, length, min, max);

  // ...........................................................................
  @override
  GgIntlist transform(int Function(int i, int val) transform) {
    return GgIntlist.generate(
      createValue: (i) => transform(i, value(i)),
      length: data.length,
      min: min,
      max: max,
    );
  }

  // ...........................................................................
  GgIntlist operator +(GgIntlist other) =>
      transform((i, val) => val + other.data[i]);

  // ######################
  // Private
  // ######################

  // ...........................................................................
  factory GgIntlist._generate(
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

    return GgIntlist(
      data: result.data,
      hashCode: result.hashCode,
      createBuffer: result.createBuffer,
      copyBuffer: result.copyBuffer,
      createSubList: result.createSubList,
      min: min,
      max: max,
    );
  }
}

// #############################################################################
final exampleGgIntList = GgIntlist.generate(
  createValue: (i) => i,
  length: 8,
  min: 0,
  max: 8,
);
