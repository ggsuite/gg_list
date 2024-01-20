// @license
// Copyright (c) 2019 - 2023 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import 'gg_2d_list.dart';
import 'int_list_factory.dart';

// #############################################################################
class Gg2dIntList extends Gg2dList<int> {
  const Gg2dIntList({
    required super.data,
    required super.dataT,
    required super.colHashes,
    required super.rowHashes,
    required super.hashCode,
    required super.createBuffer,
    required super.copyBuffer,
    required super.subList,
    required super.rowCount,
    required super.colCount,
    required this.min,
    required this.max,
  });

  // ######################
  // Generate
  // ######################

  // ...........................................................................
  factory Gg2dIntList.generate({
    required int Function(int a, int b)? createValue,
    required int min,
    required int max,
    required int rowCount,
    required int colCount,
  }) =>
      Gg2dIntList._generateIntSpace(
        createValue: createValue,
        min: min,
        max: max,
        rowCount: rowCount,
        colCount: colCount,
      );

  // ######################
  // Data
  // ######################

  // ...........................................................................
  final int min;
  final int max;

  // ######################
  // Private
  // ######################

  // ...........................................................................
  factory Gg2dIntList._generateIntSpace({
    required int Function(int a, int b)? createValue,
    required int colCount,
    required int rowCount,
    required int min,
    required int max,
  }) {
    final naf = IntListFactory(min: min, max: max);

    // Generate a basic list
    final result = Gg2dList<int>.special(
      colCount: colCount,
      rowCount: rowCount,
      createBuffer: naf.createBuffer,
      copyBuffer: naf.copyBuffer,
      subList: (p0, [start = 0, end]) =>
          naf.sublistView(p0 as TypedData, start, end),
      createValue: createValue == null
          ? null
          : (a, b) {
              final val = createValue(a, b);
              if (val < min || val > max) {
                // coverage:ignore-start
                throw RangeError('Val $val must be between $min and $max.');
                // coverage:ignore-end
              }
              return val;
            },
      minValue: min,
      maxValue: max,
    );

    return Gg2dIntList(
      data: result.data,
      dataT: result.dataT,
      rowHashes: result.rowHashes,
      colHashes: result.colHashes,
      hashCode: result.hashCode,
      createBuffer: result.createBuffer,
      copyBuffer: result.copyBuffer,
      subList: result.subList,
      rowCount: result.rowCount,
      colCount: result.colCount,
      min: min,
      max: max,
    );
  }
}
