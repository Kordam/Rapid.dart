library rapid.test.body;

import 'package:unittest/unittest.dart';
import 'package:rapid/rapid.dart';
import 'package:vector_math/vector_math.dart';

void init () {
  var b = new RigidBody.empty();
}

void main() {
  group("Body", () {
    test("Body init", init);
  });
}