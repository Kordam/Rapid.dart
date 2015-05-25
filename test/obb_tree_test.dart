library rapid.test.obb_tree;

import 'package:unittest/unittest.dart';
import 'package:rapid/rapid.dart';
import 'package:vector_math/vector_math.dart';

void testBuildPoints()
{
  var points = new List<Vector3>();
  points.add(new Vector3(1.0, 5.0, 1.0));
  points.add(new Vector3(10.0, 5.0, 12.0));
  points.add(new Vector3(15.0, 5.0, 1.0));
  points.add(new Vector3(20.0, 5.0, 0.0));
  points.add(new Vector3(-1.0, 5.0, 100.0));
  points.add(new Vector3(10.0, 8.0, 56.0));
  points.add(new Vector3(45.0, 87.0, -1.0));
  points.add(new Vector3(20.0, 7.0, 0.0));
  points.add(new Vector3(42.0, 5.0, -3.0));
  points.add(new Vector3(42.0, 56.0, 0.0));
  points.add(new Vector3(55.0, 5.0, 1.0));
  points.add(new Vector3(25.0, 125.0, -50.0));
  var tree = new ObbTree.fromPoints(points, 0);
  var box = tree.rootBox;
  expect(box.center.x, isNot(0.0));
  expect(box.center.y, isNot(0.0));
  expect(box.center.z, isNot(0.0));
}

void testBuildSplitPoints()
{
  var points = new List<Vector3>();
  points.add(new Vector3(1.0, 5.0, 1.0));
  points.add(new Vector3(10.0, 5.0, 12.0));
  points.add(new Vector3(15.0, 5.0, 1.0));
  points.add(new Vector3(20.0, 5.0, 0.0));
  points.add(new Vector3(-1.0, 5.0, 100.0));
  points.add(new Vector3(10.0, 8.0, 56.0));
  points.add(new Vector3(45.0, 87.0, -1.0));
  points.add(new Vector3(20.0, 7.0, 0.0));
  points.add(new Vector3(42.0, 5.0, -3.0));
  points.add(new Vector3(42.0, 56.0, 0.0));
  points.add(new Vector3(55.0, 5.0, 1.0));
  points.add(new Vector3(25.0, 125.0, -50.0));
  var tree = new ObbTree.fromPoints(points, 2);
  var box = tree.rootBox;
  expect(box.center.x, isNot(0.0));
  expect(box.center.y, isNot(0.0));
  expect(box.center.z, isNot(0.0));
}

void testBuildSplit2Points()
{
  var points = new List<Vector3>();
  points.add(new Vector3(1.0, 5.0, 1.0));
  points.add(new Vector3(10.0, 5.0, 12.0));
  points.add(new Vector3(15.0, 5.0, 1.0));
  points.add(new Vector3(20.0, 5.0, 0.0));
  points.add(new Vector3(-1.0, 5.0, 100.0));
  points.add(new Vector3(10.0, 8.0, 56.0));
  points.add(new Vector3(45.0, 87.0, -1.0));
  points.add(new Vector3(20.0, 7.0, 0.0));
  points.add(new Vector3(42.0, 5.0, -3.0));
  points.add(new Vector3(42.0, 56.0, 0.0));
  points.add(new Vector3(55.0, 5.0, 1.0));
  points.add(new Vector3(25.0, 125.0, -50.0));
  var tree = new ObbTree.fromPoints(points, 3);
  var box = tree.rootBox;
  expect(box.center.x, isNot(0.0));
  expect(box.center.y, isNot(0.0));
  expect(box.center.z, isNot(0.0));
}

void testCubePoints()
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


void testCubeSplitPoints()
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

  var tree = new ObbTree.fromPoints(points, 1);
  var box = tree.rootBox;
  expect(box.center.x, equals(5.0));
  expect(box.center.y, equals(5.0));
  expect(box.center.z, equals(5.0));
  expect(box.halfExtents.x, equals(5.0));
  expect(box.halfExtents.y, equals(5.0));
  expect(box.halfExtents.z, equals(5.0));
}

void testCubeTris()
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

  var tris = new List<int>();
  tris.add(0); tris.add(1); tris.add(2); //Tri front face 1
  tris.add(0); tris.add(2); tris.add(3); //Tri front face 2
  tris.add(2); tris.add(3); tris.add(5); //Tri top face 1
  tris.add(2); tris.add(5); tris.add(7); //Tri top face 2
  tris.add(0); tris.add(1); tris.add(4); //Tri bottom face 1
  tris.add(1); tris.add(4); tris.add(6); //Tri bottom face 2
  tris.add(0); tris.add(3); tris.add(4); //Tri left face 1
  tris.add(3); tris.add(4); tris.add(5); //Tri left face 2
  tris.add(1); tris.add(2); tris.add(6); //Tri right face 1
  tris.add(2); tris.add(6); tris.add(7); //Tri right face 2

  var tree = new ObbTree.fromTriangles(tris, points, 0);
  var box = tree.rootBox;
  expect(box.center.x, isNot(0.0));
  expect(box.center.y, isNot(0.0));
  expect(box.center.z, isNot(0.0));
  expect(box.halfExtents.x, isNot(0.0));
  expect(box.halfExtents.y, isNot(0.0));
  expect(box.halfExtents.z, isNot(0.0));
}

void testCubeSplitTris()
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

  var tris = new List<int>();
  tris.add(0); tris.add(1); tris.add(2); //Tri front face 1
  tris.add(0); tris.add(2); tris.add(3); //Tri front face 2
  tris.add(2); tris.add(3); tris.add(5); //Tri top face 1
  tris.add(2); tris.add(5); tris.add(7); //Tri top face 2
  tris.add(0); tris.add(1); tris.add(4); //Tri bottom face 1
  tris.add(1); tris.add(4); tris.add(6); //Tri bottom face 2
  tris.add(0); tris.add(3); tris.add(4); //Tri left face 1
  tris.add(3); tris.add(4); tris.add(5); //Tri left face 2
  tris.add(1); tris.add(2); tris.add(6); //Tri right face 1
  tris.add(2); tris.add(6); tris.add(7); //Tri right face 2

  var tree = new ObbTree.fromTriangles(tris, points, 1);
  var box = tree.rootBox;
  expect(box.center.x, isNot(0.0));
  expect(box.center.y, isNot(0.0));
  expect(box.center.z, isNot(0.0));
  expect(box.halfExtents.x, isNot(0.0));
  expect(box.halfExtents.y, isNot(0.0));
  expect(box.halfExtents.z, isNot(0.0));
}

void main()
{
  group('Obb Tree', () {
    test('Build random from points no divide', testBuildPoints);
    test('Build random from points 1 subdivision', testBuildSplitPoints);
    test('Build random from points 2 subdivisions', testBuildSplit2Points);
    test('Cube from points no divide', testCubePoints);
    test('Cube from points with 1 div', testCubeSplitPoints);
    test('Cube from triangles no div', testCubeTris);
    test('Cube from triangles 1 div', testCubeSplitTris);
  });
}