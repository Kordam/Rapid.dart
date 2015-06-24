library rapid.test.obb_tree;

import 'package:unittest/unittest.dart';
import 'package:rapid/rapid.dart';
import 'package:vector_math/vector_math.dart';

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

  var tree = new ObbTree.fromTriangles(tris, points, 2);
  var box = tree.rootBox;
  expect(box.center.x, isNot(0.0));
  expect(box.center.y, isNot(0.0));
  expect(box.center.z, isNot(0.0));
  expect(box.halfExtents.x, isNot(0.0));
  expect(box.halfExtents.y, isNot(0.0));
  expect(box.halfExtents.z, isNot(0.0));
}

void testTranslationCube() {
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

  var tree = new ObbTree.fromTriangles(tris, points, 2);

  tree.translate(new Vector3(1.0, 0.0, 0.0));
  expect(tree.rootBox.center.x, 6.0);
}

void testRotationCube() {
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

  var tree = new ObbTree.fromTriangles(tris, points, 2);

  tree.rotate(new Vector3(90.0, 0.0, 0.0));
}


void main()
{
  group('Obb Tree', () {
    test('Cube from triangles no div', testCubeTris);
    test('Cube from triangles 1 div', testCubeSplitTris);
    test('Translation cube', testTranslationCube);
    test('Rotation cube', testRotationCube);
  });
}