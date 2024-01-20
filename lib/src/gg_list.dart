// @license
// Copyright (c) 2019 - 2023 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// #############################################################################
import 'fnv1.dart';

class GgList<T> {
  // ######################
  // Constructors
  // ######################

  // ...........................................................................
  const GgList({
    required this.data,
    required this.hashCode,
    required this.createBuffer,
    required this.copyBuffer,
    required this.createSubList,
  });

  // ...........................................................................
  factory GgList.generate({
    required int length,
    required T Function(int i)? createValue,
    required T fill,
  }) {
    return GgList<T>.special(
      length: length,
      createBuffer: (length) => List<T>.filled(length, growable: false, fill),
      copyBuffer: List<T>.from,
      subList: (p0, [start = 0, end]) => p0.sublist(start, end),
      createValue: createValue == null ? null : (i) => createValue(i),
    );
  }

  // ...........................................................................
  factory GgList.special({
    required int length,
    required List<T> Function(int length) createBuffer,
    required List<T> Function(List<T>) copyBuffer,
    required List<T> Function(List<T>, int start, int? end) subList,
    T Function(int i)? createValue,
  }) =>
      _generate2(
        length: length,
        createBuffer: createBuffer,
        copyBuffer: copyBuffer,
        subList: subList,
        createValue: createValue,
      );

  // ...........................................................................
  factory GgList.fromList(
    List<T> values,
  ) =>
      GgList.generate(
        length: values.length,
        createValue: (i) => values[i],
        fill: values[0],
      );

  // ...........................................................................
  GgList.fromGgList(
    GgList<T> list,
  )   : data = list.data,
        hashCode = list.hashCode,
        createBuffer = list.createBuffer,
        copyBuffer = list.copyBuffer,
        createSubList = list.createSubList;

  // ######################
  // Copy & modify
  // ######################

  // ...........................................................................
  GgList<T> copyWithValue(int i, T value) {
    // If nothing has changed, do nothing
    final oldVal = this.value(i);
    if (oldVal == value) {
      return this;
    }

    // Copy data and hashes
    final data = copyBuffer(this.data);

    // Calculate index
    final index = i;

    // Update value
    data[index] = value;

    // Update hashes
    final hashCode = fnv1(data, 0, this.data.length);

    // Create a new object
    return GgList<T>(
      data: data,
      hashCode: hashCode,
      createBuffer: createBuffer,
      copyBuffer: copyBuffer,
      createSubList: createSubList,
    );
  }

  // ...........................................................................
  GgList<T> transform(T Function(int i, T val) transform) {
    return _generate2(
      createValue: (i) {
        return transform(i, data[i]);
      },
      copyBuffer: copyBuffer,
      createBuffer: createBuffer,
      length: data.length,
      subList: createSubList,
    );
  }

  // ######################
  // Data access
  // ######################

  // ...........................................................................
  T value(int i) => data[i];

  // ...........................................................................
  T operator [](int i) => data[i];

  // ...........................................................................
  List<T> subList(int start, int? end) => createSubList(this.data, start, end);

  // ###########################
  // Data manipulation delegates
  // ###########################

  // ...........................................................................
  final List<T> Function(int length) createBuffer;
  final List<T> Function(List<T>) copyBuffer;
  final List<T> Function(List<T>, int start, int? end) createSubList;

  // ######################
  // Data
  // ######################

  // ...........................................................................
  final List<T> data;

  @override
  final int hashCode;

  // ...........................................................................
  @override
  bool operator ==(Object other) {
    return this.hashCode == other.hashCode;
  }

  // ######################
  // Private
  // ######################

  // ...........................................................................
  static GgList<T> _generate2<T>({
    required int length,
    required List<T> Function(int length) createBuffer,
    required List<T> Function(List<T>) copyBuffer,
    required List<T> Function(List<T>, int start, int? end) subList,
    T Function(int i)? createValue,
    int? hashCode,
  }) {
    // Create buffers
    final data = createBuffer(length);

    // Generate data
    if (createValue != null) {
      for (var i = 0; i < length; i++) {
        final val = createValue(i);
        data[i] = val;
      }
    }

    hashCode ??= fnv1(data, 0, data.length);

    // Create result object
    final result = GgList<T>(
      data: data,
      hashCode: hashCode,
      createBuffer: createBuffer,
      copyBuffer: copyBuffer,
      createSubList: subList,
    );

    // Return result object
    return result;
  }
}

// #############################################################################
final exampleGgList = GgList<String>.generate(
  createValue: (i) => '$i',
  fill: '',
  length: 8,
);
