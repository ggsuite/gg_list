// Scratch probe: show that a fnv1 which CRASHES on every unaligned
// byteCount%8==0 input would still pass all assertions of the compat test,
// because compare() returns before calling fnv1 whenever the reference throws.
//
// ignore_for_file: avoid_print

import 'dart:math';
import 'dart:typed_data';

import 'package:gg_list/gg_list.dart';

int fnv1Reference(Iterable<dynamic> data, [int start = 0, int? end]) {
  const int prime = 16777619;
  int hash = 2166136261;
  hash ^= ((end ?? data.length) - start).hashCode;
  end ??= data.length;
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

/// Mutant: crashes on exactly the intentional-change inputs, correct elsewhere.
int fnv1Mutant(Iterable<dynamic> data, [int start = 0, int? end]) {
  if (data is TypedData) {
    final td = data as TypedData;
    final bytes = Int8List.sublistView(td, start, end ?? data.length);
    if (bytes.lengthInBytes % 8 == 0 && (bytes.offsetInBytes & 3) != 0) {
      throw StateError('regression: broken on unaligned %8==0 input');
    }
  }
  return fnv1(data, start, end);
}

int assertions = 0;
int failures = 0;
int mutantCrashesSeenByTest = 0;

// Exact logic of the compat test's compare(), but using the mutant.
void compare(Iterable<dynamic> data, [int start = 0, int? end]) {
  late final int expected;
  try {
    expected = fnv1Reference(data, start, end);
  } on ArgumentError {
    return; // <- identical to test/fnv1_compat_test.dart line 76
  }
  assertions++;
  int actual;
  try {
    actual = fnv1Mutant(data, start, end);
  } catch (e) {
    mutantCrashesSeenByTest++;
    failures++;
    return;
  }
  if (actual != expected) failures++;
}

void main() {
  final random = Random(42);

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
  final buffer = Uint8List.fromList(
    List<int>.generate(64, (i) => random.nextInt(256)),
  );
  for (var offset = 0; offset < 8; offset++) {
    final view = Uint8List.sublistView(buffer, offset, 61);
    compare(view);
    compare(view, 3, 20);
  }

  print('assertions executed: $assertions');
  print('failures: $failures');
  print('mutant crashes ever observed by the test: $mutantCrashesSeenByTest');
  print(
    failures == 0
        ? 'RESULT: compat test PASSES despite fnv1 crashing on all '
              'intentional-change inputs'
        : 'RESULT: compat test caught the mutant',
  );
}
