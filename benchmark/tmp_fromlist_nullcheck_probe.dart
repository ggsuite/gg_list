// Scratch probe: does the per-element `min != null` / `max != null` check in
// GgFloatList.fromList cost measurable time compared to a hoisted fast path?
//
// Loop A replicates the exact loop body of GgFloatList.fromList (new code).
// Loop B is the hypothetical fast path (null-ness hoisted out of the loop),
// like GgFloatList._generate's `min == null && max == null` branch.
//
// Also compares the full public GgFloatList.fromList (new code) against the
// old implementation route (generate with a `(i) => values[i]` closure) to
// check whether the diff regressed fromList (it should have improved it).

import 'dart:typed_data';

import 'package:gg_list/gg_list.dart';

@pragma('vm:never-inline')
Float64List loopWithPerElementNullChecks(
  List<double> values,
  double? min,
  double? max,
) {
  final length = values.length;
  final data = Float64List(length);
  for (var i = 0; i < length; i++) {
    final val = values[i];
    if ((min != null && val < min) || (max != null && val > max)) {
      throw RangeError('Val $val must be between $min and $max.');
    }
    data[i] = val;
  }
  return data;
}

@pragma('vm:never-inline')
Float64List loopHoisted(List<double> values, double? min, double? max) {
  final length = values.length;
  final data = Float64List(length);
  if (min == null && max == null) {
    for (var i = 0; i < length; i++) {
      data[i] = values[i];
    }
  } else {
    for (var i = 0; i < length; i++) {
      final val = values[i];
      if ((min != null && val < min) || (max != null && val > max)) {
        throw RangeError('Val $val must be between $min and $max.');
      }
      data[i] = val;
    }
  }
  return data;
}

// Old fromList implementation: delegate to generate with an index closure.
GgFloatList oldFromList(
  List<double> values, {
  double? min,
  double? max,
  required Type listType,
}) => GgFloatList.generate(
  createValue: (i) => values[i],
  length: values.length,
  min: min,
  max: max,
  listType: listType,
);

double timeIt(String label, int reps, Object? Function() body) {
  final sw = Stopwatch()..start();
  Object? sink;
  for (var r = 0; r < reps; r++) {
    sink = body();
  }
  sw.stop();
  final usPerRep = sw.elapsedMicroseconds / reps;
  print(
    '$label: ${usPerRep.toStringAsFixed(2)} us/rep '
    '(sink=${sink.hashCode & 0xff})',
  );
  return usPerRep;
}

void main(List<String> args) {
  const n = 100000;
  const reps = 2000;
  final values = List<double>.generate(n, (i) => (i % 997).toDouble());

  // Obtain min/max in a way the compiler cannot constant-fold.
  final double? min = args.contains('--with-min') ? 0.0 : null;
  final double? max = args.contains('--with-max') ? 1e9 : null;
  print('min=$min max=$max n=$n reps=$reps');

  // Warmup.
  for (var i = 0; i < 200; i++) {
    loopWithPerElementNullChecks(values, min, max);
    loopHoisted(values, min, max);
  }

  print('--- raw loop (no hashing, no object construction) ---');
  final a1 = timeIt(
    'A per-element null checks',
    reps,
    () => loopWithPerElementNullChecks(values, min, max),
  );
  final b1 = timeIt(
    'B hoisted fast path      ',
    reps,
    () => loopHoisted(values, min, max),
  );
  timeIt(
    'A per-element null checks',
    reps,
    () => loopWithPerElementNullChecks(values, min, max),
  );
  timeIt(
    'B hoisted fast path      ',
    reps,
    () => loopHoisted(values, min, max),
  );
  print(
    'raw-loop delta A-B: ${(a1 - b1).toStringAsFixed(2)} us/rep '
    '(${((a1 - b1) / n * 1000).toStringAsFixed(3)} ns/element)',
  );

  print('--- full factory: new GgFloatList.fromList vs old route ---');
  for (var i = 0; i < 30; i++) {
    GgFloatList.fromList(values, min: min, max: max, listType: Float64List);
    oldFromList(values, min: min, max: max, listType: Float64List);
  }
  const fReps = 300;
  final newT = timeIt(
    'new fromList (current diff)',
    fReps,
    () =>
        GgFloatList.fromList(values, min: min, max: max, listType: Float64List),
  );
  final oldT = timeIt(
    'old fromList (via generate)',
    fReps,
    () => oldFromList(values, min: min, max: max, listType: Float64List),
  );
  timeIt(
    'new fromList (current diff)',
    fReps,
    () =>
        GgFloatList.fromList(values, min: min, max: max, listType: Float64List),
  );
  timeIt(
    'old fromList (via generate)',
    fReps,
    () => oldFromList(values, min: min, max: max, listType: Float64List),
  );
  print('factory delta old-new: ${(oldT - newT).toStringAsFixed(2)} us/rep');

  // Sanity: identical results and hashes regardless of path.
  final g1 = GgFloatList.fromList(values, listType: Float64List);
  final g2 = oldFromList(values, listType: Float64List);
  final g3 = GgFloatList.fromList(
    values,
    min: -1,
    max: 1e9,
    listType: Float64List,
  );
  print(
    'hash parity new/old/bounded: '
    '${g1.hashCode == g2.hashCode && g2.hashCode == g3.hashCode}',
  );
}
