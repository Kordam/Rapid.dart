// A library inspired from the RAPID library (http://gamma.cs.unc.edu/OBB/)
// Designed to process efficient polygon interference detection
//
// This library contains an adaptation of a spacial subdivision class ([KdTree]),
// ...
//
// The interface for collision query is [World].

library rapid;

import 'dart:math';
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

part 'src/kd_tree.dart';