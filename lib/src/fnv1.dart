// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:typed_data';

// .............................................................................
/// Calculates an fnv1 hash on an list
int fnv1(Iterable<dynamic> data, [int start = 0, int? end]) {
  const int prime = 16777619;
  int hash = 2166136261; // FNV offset basis

  // Write buffer length into hashcode
  hash ^= ((end ?? data.length) - start).hashCode;

  end ??= data.length;

  // ..................................................
  // Typed data is hashed as 32 bit chunks, zero-padded
  // to a multiple of 8 bytes
  if (data is TypedData) {
    return _fnv1TypedData(hash, data as TypedData, start, end);
  }

  // ..................................................
  // Int lists are hashed with a specialized loop
  if (data is List<int>) {
    for (var i = start; i < end; i++) {
      hash = hash * prime;
      hash = hash ^ (data[i] + prime);
    }
    return hash;
  }

  // ..................................................
  // Other lists are hashed using indexed access
  if (data is List) {
    for (var i = start; i < end; i++) {
      final val = data[i];
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

  // ..................................................
  // Any other iterables are hashed using elementAt
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
/// Hashes the bytes of [data] between [start] and [end] (in elements of
/// [data]) as signed little-endian 32 bit chunks, zero-padded to a multiple
/// of 8 bytes.
int _fnv1TypedData(int hash, TypedData data, int start, int end) {
  const int prime = 16777619;

  final bytes = Int8List.sublistView(data, start, end);
  final byteCount = bytes.length;

  // The number of 32 bit chunks after zero-padding to a multiple of 8 bytes
  final chunkCount = ((byteCount + 7) >> 3) << 1;
  final fullChunkCount = byteCount >> 2;

  // ..........................................
  // Hash all complete 4-byte chunks
  var b = 0;
  if ((bytes.offsetInBytes & 3) == 0) {
    // Aligned data can be read as 32 bit values directly
    final chunks = Int32List.sublistView(bytes, 0, fullChunkCount << 2);
    for (var i = 0; i < chunks.length; i++) {
      hash = hash * prime;
      hash = hash ^ (chunks[i] + prime);
    }
    b = fullChunkCount << 2;
  } else {
    // Unaligned data is assembled byte by byte.
    // Assumes a little-endian host, which is true for all Dart platforms.
    for (var i = 0; i < fullChunkCount; i++) {
      final chunk =
          (bytes[b] & 0xFF) |
          ((bytes[b + 1] & 0xFF) << 8) |
          ((bytes[b + 2] & 0xFF) << 16) |
          (bytes[b + 3] << 24);
      hash = hash * prime;
      hash = hash ^ (chunk + prime);
      b += 4;
    }
  }

  // ..........................................
  // Hash the remaining bytes as one zero-padded chunk
  var writtenChunkCount = fullChunkCount;
  if (b < byteCount) {
    var chunk = 0;
    var shift = 0;
    while (b < byteCount) {
      chunk |= (bytes[b] & 0xFF) << shift;
      shift += 8;
      b++;
    }
    hash = hash * prime;
    hash = hash ^ (chunk + prime);
    writtenChunkCount++;
  }

  // ..........................................
  // Hash the zero chunks completing the padding
  for (var i = writtenChunkCount; i < chunkCount; i++) {
    hash = hash * prime;
    hash = hash ^ prime;
  }

  return hash;
}
