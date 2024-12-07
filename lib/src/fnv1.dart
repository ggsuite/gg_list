// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// .............................................................................
/// Calculates an fnv1 hash on an list
int fnv1(Iterable<dynamic> data, [int start = 0, int? end]) {
  const int prime = 16777619;
  int hash = 2166136261; // FNV offset basis

  // Write buffer length into hashcode
  hash ^= ((end ?? data.length) - start).hashCode;

  end ??= data.length;

  // Calculate hashcode
  for (int i = start; i < end; i++) {
    final val = data.elementAt(i);
    hash = hash * prime; // Multiply the current hash with the prime
    hash = hash ^
        ((val is Enum)
            ? val.name.hashCode
            : val is int
                ? val + prime
                : val.hashCode); // XOR with the current data
  }

  return hash;
}
