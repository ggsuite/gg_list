// @license
// Copyright (c) 2019 - 2026 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:math';
import 'dart:typed_data';

import 'package:gg_list/gg_list.dart';
import 'package:test/test.dart';

// .............................................................................
/// The original fnv1 implementation, kept as a reference to guarantee that
/// the optimized implementation produces identical hash values.
int fnv1Reference(Iterable<dynamic> data, [int start = 0, int? end]) {
  const int prime = 16777619;
  int hash = 2166136261; // FNV offset basis

  // Write buffer length into hashcode
  hash ^= ((end ?? data.length) - start).hashCode;

  end ??= data.length;

  // If data is typed data, convert it to 32 bit chunks
  if (data is TypedData) {
    final typedData = Int8List.sublistView(data as TypedData, start, end);
    final byteCount = typedData.lengthInBytes;
    final isDevidableBy8 = byteCount % 8 == 0;

    if (!isDevidableBy8) {
      final requiredByteCount = byteCount % 8 > 0
          ? (byteCount ~/ 8 + 1) * 8
          : byteCount;
      final dataNew = Uint8List(requiredByteCount);
      dataNew.setRange(0, byteCount, typedData);
      start = 0;
      end = requiredByteCount;
      data = dataNew;
    }

    data = Int32List.sublistView(data as TypedData, start, end);
    start = 0;
    end = data.length;
  }

  for (int i = start; i < end; i++) {
    final val = data.elementAt(i);
    hash = hash * prime;
    hash =
        hash ^
        ((val is Enum)
            ? val.name.hashCode
            : val is int
            ? val + prime
            : val.hashCode);
  }

  return hash;
}

// .............................................................................
enum TestEnum { a, b, c }

void main() {
  final random = Random(42);

  void compare(Iterable<dynamic> data, [int start = 0, int? end]) {
    late final int expected;
    try {
      expected = fnv1Reference(data, start, end);
    } on ArgumentError {
      // The reference implementation throws on unaligned typed data views
      // whose byte count is divisible by 8. The optimized implementation
      // handles these cases. No reference value to compare against, but
      // the optimized implementation must not throw.
      expect(() => fnv1(data, start, end), returnsNormally);
      return;
    }
    expect(
      fnv1(data, start, end),
      expected,
      reason:
          'fnv1 mismatch for ${data.runtimeType} '
          'length ${data.length}, start $start, end $end',
    );
  }

  group('fnv1 produces the same values as the original implementation', () {
    test('for all typed data types and lengths from 0 to 40', () {
      final buildersInt = <TypedData Function(List<int>)>[
        Uint8List.fromList,
        Int8List.fromList,
        Uint16List.fromList,
        Int16List.fromList,
        Uint32List.fromList,
        Int32List.fromList,
        Uint64List.fromList,
        Int64List.fromList,
      ];

      for (final build in buildersInt) {
        for (var length = 0; length <= 40; length++) {
          final values = List<int>.generate(
            length,
            (i) => random.nextInt(1 << 32) - (1 << 31),
          );
          compare(build(values) as Iterable<dynamic>);
        }
      }
    });

    test('for float typed data types and lengths from 0 to 40', () {
      for (var length = 0; length <= 40; length++) {
        final values = List<double>.generate(
          length,
          (i) => (random.nextDouble() - 0.5) * 1e9,
        );
        compare(Float32List.fromList(values));
        compare(Float64List.fromList(values));
      }
    });

    test('for sub-ranges of typed data', () {
      final data8 = Uint8List.fromList(
        List<int>.generate(64, (i) => random.nextInt(256)),
      );
      final data16 = Uint16List.fromList(
        List<int>.generate(64, (i) => random.nextInt(1 << 16)),
      );
      final data64 = Int64List.fromList(
        List<int>.generate(64, (i) => random.nextInt(1 << 32)),
      );

      for (var start = 0; start < 16; start++) {
        for (var end = start; end <= 64; end++) {
          compare(data8, start, end);
          compare(data16, start, end);
          compare(data64, start, end);
        }
      }
    });

    test('for views with a non-zero offset into a buffer', () {
      final buffer = Uint8List.fromList(
        List<int>.generate(64, (i) => random.nextInt(256)),
      );
      for (var offset = 0; offset < 8; offset++) {
        final view = Uint8List.sublistView(buffer, offset, 61);
        compare(view);
        compare(view, 3, 20);
      }
    });

    test('for plain int lists', () {
      for (var length = 0; length <= 40; length++) {
        final values = List<int>.generate(
          length,
          (i) => random.nextInt(1 << 32) - (1 << 31),
        );
        compare(values);
        if (length >= 4) {
          compare(values, 2, length - 1);
        }
      }
    });

    test('for string, enum, double, mixed and iterable data', () {
      compare(['a', 'b', 'c']);
      compare(List<String>.generate(20, (i) => 'value$i'));
      compare([TestEnum.a, TestEnum.b, TestEnum.c]);
      compare(<dynamic>['a', 1, 2.5, TestEnum.b, null, true]);
      compare(List<double>.generate(20, (i) => i * 1.5));
      compare(Iterable<int>.generate(20, (i) => i * 3));
    });
  });
}
