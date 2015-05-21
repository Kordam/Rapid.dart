library rapid.test.obb_tree;

import 'package:unittest/unittest.dart';
import 'package:rapid/rapid.dart';
import 'package:vector_math/vector_math.dart';

void testBuild()
{
  var points = new List<Vector3>();
  points.add(new Vector3(1.0, 5.0, 1.0));
  points.add(new Vector3(10.0, 5.0, 0.0));
  points.add(new Vector3(15.0, 5.0, 1.0));
  points.add(new Vector3(20.0, 5.0, 0.0));
  var tree = new ObbTree.fromPoints(points, 0);
  var box = tree.rootBox;
  expect(box.center.x, isNot(0.0));
  expect(box.center.y, isNot(0.0));
  expect(box.center.z, isNot(0.0));
}

void testCube()
{
  var points = new List<Vector3>();
  points.add(new Vector3(0.0, 0.0, 0.0)); // Top face bl
  points.add(new Vector3(10.0, 0.0, 0.0)); // Top face br
  points.add(new Vector3(10.0, 10.0, 0.0)); // Top face tr
  points.add(new Vector3(0.0, 10.0, 0.0)); // Top face tl
  points.add(new Vector3(0.0, 0.0, 10.0)); //Left face bl
  points.add(new Vector3(0.0, 10.0, 10.0)); //Left face tl
  points.add(new Vector3(10.0, 0.0, 10.0)); //Right face bl
  points.add(new Vector3(10.0, 10.0, 10.0)); //Right face tl

  var tree = new ObbTree.fromPoints(points, 0);
  var box = tree.rootBox;
  expect(box.center.x, equals(5.0));
  expect(box.center.y, equals(5.0));
  expect(box.center.z, equals(5.0));
  expect(box.halfExtents.x, equals(5.0));
  expect(box.halfExtents.y, equals(5.0));
  expect(box.halfExtents.z, equals(5.0));
}

void main()
{
  group('Obb Tree', () {
    test('Build random', testBuild);
    test('Cube', testCube);
  });
}