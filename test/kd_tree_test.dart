library rapid.test.kd_tree_test;

import 'package:unittest/unittest.dart';
import 'package:vector_math/vector_math.dart';
import 'package:rapid/rapid.dart';

void testBuild()
{
  var kd = new KdTree.fromList([], []);
  var n = kd.nearest(new Vector3(0.0, 0.0, 0.0));
  expect(n, null);
}

void testBuildFromList()
{
  var li = [];
  li.add(new Vector3(10.0, 0.0, 0.0));
  li.add(new Vector3(-10.0, 0.0, 0.0));
  li.add(new Vector3(0.0, 10.0, 0.0));
  li.add(new Vector3(0.0, -10.0, 0.0));
  li.add(new Vector3(0.0, 0.0, 10.0));
  li.add(new Vector3(0.0, 0.0, -10.0));
  //Test to stores points duplicate as data
  var kd = new KdTree.fromList(li, li);
}

void testInsert()
{
  var kd = new KdTree.fromList([new Vector3(4.0, 0.0, 0.0)], ["Testinsert"]);
  kd.insert(new Vector3(1.0, 1.0, 1.0), "to find");
  var node = kd.exact(new Vector3(1.0, 1.0, 1.0));
  expect(node.tag, "to find");
}

void testRemove()
{
  var v3 = new Vector3(4.0, 0.0, 0.0);
  var kd = new KdTree.fromList([v3], ["TestRemove"]);
  kd.remove(v3);
  var n = kd.exact(v3);
  expect(n, null);
}

void testSearchNear()
{
  var li = [];
  li.add(new Vector3(10.0, 0.0, 0.0));
  li.add(new Vector3(-10.0, 0.0, 0.0));
  li.add(new Vector3(0.0, 10.0, 0.0));
  li.add(new Vector3(0.0, -10.0, 0.0));
  li.add(new Vector3(0.0, 0.0, 10.0));
  li.add(new Vector3(0.0, 0.0, -10.0));
  //Test to stores points duplicate as data
  var kd = new KdTree.fromList(li, li);
  var n = kd.nearest(new Vector3(8.0, 0.0, 0.0));
  expect(n.tag.x, 10.0);
}

void testSearchMultiNear()
{
  var li = [];
  li.add(new Vector3(10.0, 0.0, 0.0));
  li.add(new Vector3(-10.0, 0.0, 0.0));
  li.add(new Vector3(0.0, 10.0, 0.0));
  li.add(new Vector3(0.0, -10.0, 0.0));
  li.add(new Vector3(0.0, 0.0, 10.0));
  li.add(new Vector3(0.0, 0.0, -10.0));
  //Test to stores points duplicate as data
  var kd = new KdTree.fromList(li, li);
  var n = kd.nearestMultiple(new Vector3(8.0, 0.0, 0.0), 6);
  expect(n.length, 6);
}

void main()
{
  group('KdTree', () {
    test('Build', testBuild);
    test('Build from list', testBuildFromList);
    test('Insert', testInsert);
    test('Remove', testRemove);
    test('Search nearest', testSearchNear);
    test('Search multiple nearest', testSearchMultiNear);
  });
}