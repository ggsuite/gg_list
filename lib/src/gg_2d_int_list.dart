// @license
// Copyright (c) 2019 - 2023 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

import 'gg_2d_list.dart';
import 'int_list_factory.dart';

// #############################################################################
/// Effectively manages 2d ints as native arrays
class Gg2dIntList extends Gg2dList<int> {
  /// The default constructor
  const Gg2dIntList({
    required super.data,
    required super.dataT,
    required super.colHashes,
    required super.rowHashes,
    required super.hashCode,
    required super.createData,
    required super.copyData,
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
  /// Generates a 2d list
  ///
  /// - [createValue] - A callback creating the value for a given row/col
  /// - [min] - The minimum value an array item can have
  /// - [max] - The maximum value an array item can have
  /// - [rowCount] - The number of rows
  /// - [colCount] - The number of columns
  factory Gg2dIntList.generate({
    required int Function(int col, int row)? createValue,
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
  /// The minimum allowed value
  final int min;

  /// The maximum allowed value
  final int max;

  // ######################
  // Private
  // ######################

  // ...........................................................................
  factory Gg2dIntList._generateIntSpace({
    required int Function(int col, int row)? createValue,
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
          : (col, row) {
              final val = createValue(col, row);
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
      createData: result.createData,
      copyData: result.copyData,
      subList: result.subList,
      rowCount: result.rowCount,
      colCount: result.colCount,
      min: min,
      max: max,
    );
  }
}
