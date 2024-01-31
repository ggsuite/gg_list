// @license
// Copyright (c) 2019 - 2023 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// #############################################################################
import 'dart:math';

import 'fnv1.dart';

/// A list that can contain multiple arbitrary values
class GgList<T> implements List<T> {
  // ######################
  // Constructors
  // ######################

  // ...........................................................................
  /// The constructor
  const GgList({
    required List<T> data,
    required this.hashCode,
    required this.createData,
    required this.copyData,
    required this.createSubList,
  }) : _data = data;

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
  )   : _data = list._data,
        hashCode = list.hashCode,
        createData = list.createData,
        copyData = list.copyData,
        createSubList = list.createSubList;

  // ######################
  // Copy & modify
  // ######################

  // ...........................................................................
  /// Copies the list and changes the value at index [i]
  GgList<T> copyWithValue(int i, T value) {
    // If nothing has changed, do nothing
    final oldVal = this.value(i);
    if (oldVal == value) {
      return this;
    }

    // Copy data and hashes
    final data = copyData(this._data);

    // Calculate index
    final index = i;

    // Update value
    data[index] = value;

    // Update hashes
    final hashCode = fnv1(data, 0, this._data.length);

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
        return transform(i, _data[i]);
      },
      copyBuffer: copyData,
      createBuffer: createData,
      length: _data.length,
      subList: createSubList,
    );
  }

  // ######################
  // Data access
  // ######################

  // ...........................................................................
  /// Returns the list value at index [i]
  T value(int i) => _data[i];

  // ...........................................................................
  /// Returns the list value at index [i]
  @override
  T operator [](int i) => _data[i];

  // ...........................................................................
  /// Returns a sublist
  List<T> subList(int start, int? end) => createSubList(this._data, start, end);

  // ...........................................................................
  @override
  String toString() => _data.join(', ');

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

  /// The hashcode representing the content of all elements
  @override
  final int hashCode;

  // ...........................................................................
  @override
  bool operator ==(Object other) {
    return this.hashCode == other.hashCode;
  }

  // ######################
  // List methods
  // ######################

  // coverage:ignore-start

  @override
  Iterator<T> get iterator => _data.iterator;

  @override
  bool any(bool Function(T element) test) => _data.any(test);

  @override
  List<R> cast<R>() => _data.cast<R>();

  @override
  bool contains(Object? element) => _data.contains(element);

  @override
  T elementAt(int index) => _data.elementAt(index);

  @override
  bool every(bool Function(T element) test) => _data.every(test);

  @override
  Iterable<T> followedBy(Iterable<T> other) => _data.followedBy(other);

  @override
  void forEach(void Function(T element) action) => _data.forEach(action);

  @override
  String join([String separator = '']) => _data.join(separator);

  @override
  T get last => _data.last;

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _data.lastWhere(test, orElse: orElse);

  @override
  Iterable<R> map<R>(R Function(T e) f) => _data.map(f);

  @override
  T reduce(T Function(T value, T element) combine) => _data.reduce(combine);

  @override
  T get single => _data.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _data.singleWhere(test, orElse: orElse);

  @override
  Iterable<T> skip(int count) => _data.skip(count);

  @override
  Iterable<T> skipWhile(bool Function(T value) test) => _data.skipWhile(test);

  @override
  Iterable<T> take(int count) => _data.take(count);

  @override
  Iterable<T> takeWhile(bool Function(T value) test) => _data.takeWhile(test);

  @override
  List<T> toList({bool growable = true}) => _data.toList(growable: growable);

  @override
  Set<T> toSet() => _data.toSet();

  @override
  Iterable<T> where(bool Function(T element) test) => _data.where(test);

  @override
  Iterable<R> whereType<R>() => _data.whereType<R>();

  @override
  bool get isEmpty => _data.isEmpty;

  @override
  bool get isNotEmpty => _data.isNotEmpty;

  @override
  Iterable<R> expand<R>(Iterable<R> Function(T element) f) => _data.expand(f);

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) =>
      _data.firstWhere(test, orElse: orElse);

  @override
  R fold<R>(R initialValue, R Function(R previousValue, T element) combine) =>
      _data.fold(initialValue, combine);

  @override
  T get first => _data.first;

  @override
  int get length => _data.length;

  UnsupportedError get _immutableError =>
      UnsupportedError('This list is immutable.');

  @override
  void operator []=(int index, T value) => throw _immutableError;

  @override
  set first(T value) => throw _immutableError;

  @override
  set last(T value) => throw _immutableError;

  @override
  set length(int newLength) => throw _immutableError;

  @override
  void add(T value) => throw _immutableError;

  @override
  void addAll(Iterable<T> iterable) => throw _immutableError;

  @override
  Iterable<T> get reversed => _data.reversed;

  @override
  void sort([int Function(T a, T b)? compare]) => throw _immutableError;

  @override
  void shuffle([Random? random]) => throw _immutableError;

  @override
  int indexOf(T element, [int start = 0]) => _data.indexOf(element, start);

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) =>
      _data.indexWhere(test, start);

  @override
  int lastIndexWhere(bool Function(T element) test, [int? start]) =>
      _data.lastIndexWhere(test, start);

  @override
  int lastIndexOf(T element, [int? start]) => _data.lastIndexOf(element, start);

  @override
  void clear() => throw _immutableError;

  @override
  void insert(int index, T element) => throw _immutableError;

  @override
  void insertAll(int index, Iterable<T> iterable) => throw _immutableError;

  @override
  void setAll(int index, Iterable<T> iterable) => throw _immutableError;

  @override
  bool remove(Object? value) => throw _immutableError;

  @override
  T removeAt(int index) => throw _immutableError;

  @override
  T removeLast() => throw _immutableError;

  @override
  void removeWhere(bool Function(T element) test) => throw _immutableError;

  @override
  void retainWhere(bool Function(T element) test) => throw _immutableError;

  @override
  List<T> operator +(List<T> other) => _data + other;

  @override
  List<T> sublist(int start, [int? end]) => _data.sublist(start, end);

  @override
  Iterable<T> getRange(int start, int end) => _data.getRange(start, end);

  @override
  void setRange(
    int start,
    int end,
    Iterable<T> iterable, [
    int skipCount = 0,
  ]) =>
      throw _immutableError;

  @override
  void removeRange(int start, int end) => throw _immutableError;

  @override
  void fillRange(int start, int end, [T? fillValue]) => throw _immutableError;

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) =>
      throw _immutableError;

  @override
  Map<int, T> asMap() => _data.asMap();

  // coverage:ignore-end

  // ######################
  // Private
  // ######################

  // ...........................................................................
  /// The actual data of the list
  final List<T> _data;

  /// Returns the actual data of the list
  Iterable<T> get data => _data;

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
