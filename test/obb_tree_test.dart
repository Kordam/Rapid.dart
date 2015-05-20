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
  var box = tree.boxes.first;
  expect(box.center.x, isNot(0.0));
  expect(box.center.y, isNot(0.0));
  expect(box.center.z, isNot(0.0));
}

void testInsert()
{

}

void main()
{
  group('Obb Tree', () {
    test('Build', testBuild);
    test('Insert', testInsert);
  });
}