// @license
// Copyright (c) 2019 - 2023 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// #############################################################################
import 'fnv1.dart';

/// A list that can contain multiple arbitrary values
class GgList<T> {
  // ######################
  // Constructors
  // ######################

  // ...........................................................................
  /// The constructor
  const GgList({
    required this.data,
    required this.hashCode,
    required this.createData,
    required this.copyData,
    required this.createSubList,
  });

  // ...........................................................................
  /// Creates a list of [length] using [createValue] delegate.
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
  /// Generate the list from another list
  factory GgList.fromList(
    List<T> values,
  ) =>
      GgList.generate(
        length: values.length,
        createValue: (i) => values[i],
        fill: values[0],
      );

  // ...........................................................................
  /// Derived classes can use this constructor to initialize itself based
  /// on a GgList
  GgList.fromGgList(
    GgList<T> list,
  )   : data = list.data,
        hashCode = list.hashCode,
        createData = list.createData,
        copyData = list.copyData,
        createSubList = list.createSubList;

  // ######################
  // Copy & modify
  // ######################

  // ...........................................................................
  /// Copies the list and changes the value at index [i]
  GgList<T> setValue(int i, T value) {
    // If nothing has changed, do nothing
    final oldVal = this.value(i);
    if (oldVal == value) {
      return this;
    }

    // Copy data and hashes
    final data = copyData(this.data);

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
      createData: createData,
      copyData: copyData,
      createSubList: createSubList,
    );
  }

  // ...........................................................................
  /// Copies the lists and transforms all elements using [transform] delegate
  GgList<T> transform(T Function(int i, T val) transform) {
    return _generate(
      createValue: (i) {
        return transform(i, data[i]);
      },
      copyBuffer: copyData,
      createBuffer: createData,
      length: data.length,
      subList: createSubList,
    );
  }

  // ######################
  // Data access
  // ######################

  // ...........................................................................
  /// Returns the list value at index [i]
  T value(int i) => data[i];

  // ...........................................................................
  /// Returns the list value at index [i]
  T operator [](int i) => data[i];

  // ...........................................................................
  /// Returns a sublist
  List<T> subList(int start, int? end) => createSubList(this.data, start, end);

  // ###########################
  // Data manipulation delegates
  // ###########################

  // ...........................................................................
  /// The delegate for creating the data
  final List<T> Function(int length) createData;

  /// The delegate for copying the data
  final List<T> Function(List<T>) copyData;

  /// The delegate for creating a sublist
  final List<T> Function(List<T>, int start, int? end) createSubList;

  // ######################
  // Data
  // ######################

  // ...........................................................................
  /// The actual data of the list
  final List<T> data;

  /// The hashcode representing the content of all elements
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
  /// Only used by derived classes
  factory GgList.special({
    required int length,
    required List<T> Function(int length) createBuffer,
    required List<T> Function(List<T>) copyBuffer,
    required List<T> Function(List<T>, int start, int? end) subList,
    T Function(int i)? createValue,
  }) =>
      _generate(
        length: length,
        createBuffer: createBuffer,
        copyBuffer: copyBuffer,
        subList: subList,
        createValue: createValue,
      );

  // ...........................................................................
  static GgList<T> _generate<T>({
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
      createData: createBuffer,
      copyData: copyBuffer,
      createSubList: subList,
    );

    // Return result object
    return result;
  }
}

// #############################################################################
/// An example list mainly for test purposes
final exampleGgList = GgList<String>.generate(
  createValue: (i) => '$i',
  fill: '',
  length: 8,
);
