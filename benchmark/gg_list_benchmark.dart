// @license
// Copyright (c) ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:gg_list/gg_list.dart';

/// Sink preventing dead-code elimination
int sink = 0;

// .............................................................................
/// Runs [body] repeatedly for ~300ms and returns nanoseconds per operation.
double measure(String name, void Function() body) {
  // Warmup
  for (var i = 0; i < 20; i++) {
    body();
  }

  // Measure
  final watch = Stopwatch()..start();
  var iterations = 0;
  do {
    body();
    iterations++;
  } while (watch.elapsedMicroseconds < 300000);
  watch.stop();

  final nsPerOp = watch.elapsedMicroseconds * 1000 / iterations;
  print('${name.padRight(42)} ${nsPerOp.toStringAsFixed(1).padLeft(14)} ns/op');
  return nsPerOp;
}

// .............................................................................
void main() {
  print('--- gg_list benchmark ---');

  // ...........................................................................
  // fnv1 on typed data
  final int32Data = Int32List.fromList(
    List.generate(10000, (i) => i * 2654435761 & 0x7FFFFFFF),
  );
  measure('fnv1 Int32List(10k)', () => sink ^= fnv1(int32Data));

  final uint8Data = Uint8List.fromList(List.generate(10000, (i) => i & 0xFF));
  measure('fnv1 Uint8List(10k)', () => sink ^= fnv1(uint8Data));

  final uint16Odd = Uint16List.fromList(
    List.generate(10001, (i) => i & 0xFFFF),
  );
  measure('fnv1 Uint16List(10k+1, padded)', () => sink ^= fnv1(uint16Odd));

  final float64Data = Float64List.fromList(
    List.generate(10000, (i) => i * 1.5),
  );
  measure('fnv1 Float64List(10k)', () => sink ^= fnv1(float64Data));

  // ...........................................................................
  // fnv1 on plain lists
  final plainInts = List<int>.generate(10000, (i) => i, growable: false);
  measure('fnv1 List<int>(10k)', () => sink ^= fnv1(plainInts));

  final strings = List<String>.generate(1000, (i) => 'str$i', growable: false);
  measure('fnv1 List<String>(1k)', () => sink ^= fnv1(strings));

  // ...........................................................................
  // GgList (generic)
  measure(
    'GgList<int>.generate(10k)',
    () => sink ^= GgList<int>.generate(
      length: 10000,
      createValue: (i) => i,
      fill: 0,
    ).hashCode,
  );

  measure(
    'GgList<String>.fromList(1k)',
    () => sink ^= GgList<String>.fromList(strings).hashCode,
  );

  final genericList = GgList<int>.generate(
    length: 10000,
    createValue: (i) => i,
    fill: 0,
  );
  measure(
    'GgList<int>.copyWithValue(10k)',
    () => sink ^= genericList.copyWithValue(5000, sink & 0xFF).hashCode,
  );

  // ...........................................................................
  // GgIntList
  measure(
    'GgIntList.generate(10k, uint8)',
    () => sink ^= GgIntList.generate(
      createValue: (i) => i & 0xFF,
      length: 10000,
      min: 0,
      max: 255,
    ).hashCode,
  );

  measure(
    'GgIntList.generate(10k, int64)',
    () => sink ^= GgIntList.generate(
      createValue: (i) => i,
      length: 10000,
    ).hashCode,
  );

  measure(
    'GgIntList.fromList(10k)',
    () => sink ^= GgIntList.fromList(plainInts, min: 0, max: 65535).hashCode,
  );

  final intList = GgIntList.generate(
    createValue: (i) => i & 0x7F,
    length: 10000,
    min: 0,
    max: 255,
  );
  measure(
    'GgIntList.copyWithValue(10k)',
    () => sink ^= intList.copyWithValue(5000, sink & 0xFF).hashCode,
  );

  measure(
    'GgIntList.addOneByOne(10k)',
    () => sink ^= intList.addOneByOne(intList).hashCode,
  );

  // ...........................................................................
  // GgFloatList
  measure(
    'GgFloatList.generate(10k, f32)',
    () => sink ^= GgFloatList.generate(
      createValue: (i) => i.toDouble(),
      length: 10000,
      listType: Float32List,
    ).hashCode,
  );

  // ...........................................................................
  // Gg2dList
  measure(
    'Gg2dIntList.generate(100x100)',
    () => sink ^= Gg2dIntList.generate(
      createValue: (col, row) => (col + row) & 0xFF,
      min: 0,
      max: 255,
      rowCount: 100,
      colCount: 100,
    ).hashCode,
  );

  final int2d = Gg2dIntList.generate(
    createValue: (col, row) => (col + row) & 0xFF,
    min: 0,
    max: 255,
    rowCount: 100,
    colCount: 100,
  );
  measure(
    'Gg2dIntList.setValue(100x100)',
    () => sink ^= int2d.setValue(50, 50, sink & 0xFF).hashCode,
  );

  measure(
    'Gg2dList<String>.generate(50x50)',
    () => sink ^= Gg2dList.generate(
      createValue: (col, row) => 'v',
      fill: '',
      rowCount: 50,
      colCount: 50,
    ).hashCode,
  );

  // ...........................................................................
  // GgRowList
  measure(
    'GgRowList.generate(100x100)',
    () => sink ^= GgRowList<int>.generate(
      numRows: 100,
      createRow: (i) =>
          GgList<int>.generate(length: 100, createValue: (j) => j, fill: 0),
    ).hashCode,
  );

  print('sink: $sink');
}
