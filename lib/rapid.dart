// The rapid.dart library is designed to process efficient
// rigid body simulation with polygon interference detection
//
// This library contains an adaptation of a spacial subdivision class ([KdTree]),
// ...
// The interface for collision query is [World].

library rapid;

import 'dart:math';
import 'dart:typed_data';
import 'dart:async';

import 'package:vector_math/vector_math.dart';

part 'src/kd_tree.dart';
part 'src/collider.dart';
part 'src/collision.dart';
part 'src/world.dart';
part 'src/obb_tree.dart';
part 'src/exception.dart';

part 'utils/vector_math_ext_obb.dart';
part 'utils/vector_math_ext_matrix3.dart';
part 'utils/vector_math_ext_plane.dart';