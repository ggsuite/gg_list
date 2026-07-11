// Scratch probe: verify that the compat test's compare() silently skips
// exactly the intentional-change inputs (unaligned view, byteCount % 8 == 0),
// and check what the new fnv1 does on them.
//
// ignore_for_file: avoid_print

import 'dart:math';
import 'dart:typed_data';

import 'package:gg_list/gg_list.dart';

// Verbatim copy of fnv1Reference from test/fnv1_compat_test.dart
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

int compared = 0;
int skipped = 0;
int newFnv1ThrewOnSkipped = 0;
int alignedCopyMatches = 0;
int alignedCopyMismatches = 0;
Object? firstError;

// Replicates the compat test's compare(), instrumented.
void compare(Iterable<dynamic> data, [int start = 0, int? end]) {
  late final int expected;
  try {
    expected = fnv1Reference(data, start, end);
  } on ArgumentError catch (e) {
    // This is the branch the compat test takes: it RETURNS, never calling
    // the new fnv1. Here we instead probe what the new fnv1 does.
    skipped++;
    firstError ??= e;
    int actual;
    try {
      actual = fnv1(data, start, end);
    } catch (err) {
      newFnv1ThrewOnSkipped++;
      return;
    }
    // Stronger property from the finding: new fnv1 on the unaligned view
    // equals fnv1Reference on an aligned copy of the same bytes with the
    // same element count.
    final td = data as TypedData;
    final e2 = end ?? data.length;
    final bytes = Int8List.sublistView(td, start, e2);
    final alignedBytes = Uint8List.fromList(bytes);
    final elemSize = td.elementSizeInBytes;
    final TypedData alignedCopy;
    switch (elemSize) {
      case 1:
        alignedCopy = alignedBytes;
      case 2:
        alignedCopy = Uint16List.sublistView(alignedBytes);
      case 4:
        alignedCopy = Uint32List.sublistView(alignedBytes);
      default:
        alignedCopy = Uint64List.sublistView(alignedBytes);
    }
    final ref = fnv1Reference(alignedCopy as Iterable<dynamic>);
    if (actual == ref) {
      alignedCopyMatches++;
    } else {
      alignedCopyMismatches++;
    }
    return;
  }
  compared++;
  final actual = fnv1(data, start, end);
  if (actual != expected) {
    print('MISMATCH on compared case: ${data.runtimeType} $start $end');
  }
}

void main() {
  final random = Random(42);

  // --- replicate 'for sub-ranges of typed data' test exactly ---
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
  print('--- sub-range sweep ---');
  print('compared: $compared, skipped: $skipped');

  // --- replicate 'for views with a non-zero offset' test exactly ---
  final sweepSkipped = skipped;
  final buffer = Uint8List.fromList(
    List<int>.generate(64, (i) => random.nextInt(256)),
  );
  for (var offset = 0; offset < 8; offset++) {
    final view = Uint8List.sublistView(buffer, offset, 61);
    compare(view);
    compare(view, 3, 20);
  }
  print('--- offset-view test ---');
  print('additional skipped: ${skipped - sweepSkipped}');

  print('--- totals ---');
  print('compared: $compared');
  print('skipped (reference threw, compat test asserts NOTHING): $skipped');
  print('new fnv1 threw on skipped inputs: $newFnv1ThrewOnSkipped');
  print('aligned-copy property matches: $alignedCopyMatches');
  print('aligned-copy property mismatches: $alignedCopyMismatches');
  print('error type: ${firstError.runtimeType}');
  print('error is ArgumentError: ${firstError is ArgumentError}');
  print('error message: $firstError');

  // --- the finding's concrete example ---
  final buf = Uint8List.fromList(List<int>.generate(16, (i) => i * 7 + 3));
  final view = Uint8List.sublistView(buf, 1, 9); // offset 1, length 8
  print('--- example: Uint8List view offset 1 length 8 ---');
  try {
    fnv1Reference(view);
    print('reference did NOT throw (unexpected)');
  } on ArgumentError catch (e) {
    print('reference threw: ${e.runtimeType}: $e');
  }
  final h = fnv1(view);
  final alignedH = fnv1Reference(Uint8List.fromList(view));
  print('new fnv1(view) = $h');
  print('fnv1Reference(aligned copy) = $alignedH');
  print('equal: ${h == alignedH}');
}
