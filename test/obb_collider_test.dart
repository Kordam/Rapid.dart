library rapid.test.collider_test;

import 'package:unittest/unittest.dart';
import 'package:rapid/rapid.dart';
import 'package:vector_math/vector_math.dart';

void testBuild() {

}

void testCollideSameCube() {
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

  ObbCollider c1 = new ObbCollider.fromTriangles(tris, points);
  ObbCollider c2 = new ObbCollider.fromTriangles(tris, points);
  expect(c1.collideWith(c2), equals(true));
}

void testNoCollideCubeX()
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

  ObbCollider c1 = new ObbCollider.fromTriangles(tris, points);
  ObbCollider c2 = new ObbCollider.fromTriangles(tris, points);
  //Translate method should be available
  //c2.translate(new Vector3(10.1, 0.0, 0.0));
  expect(c1.collideWith(c2), equals(false));
}

void testCollideCubeX()
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

  ObbCollider c1 = new ObbCollider.fromTriangles(tris, points);
  ObbCollider c2 = new ObbCollider.fromTriangles(tris, points);
  //Translate method should be available
  //c2.translate(new Vector3(5.0, 0.0, 0.0));
  expect(c1.collideWith(c2), equals(false));
}

void testNoCollideCubeY()
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

  ObbCollider c1 = new ObbCollider.fromTriangles(tris, points);
  ObbCollider c2 = new ObbCollider.fromTriangles(tris, points);
  //Translate method should be available
  //c2.translate(new Vector3(0.5, 10.1, 0.0));
  expect(c1.collideWith(c2), equals(false));
}

void main()
{
  group('Collider', () {
    test('Build', testBuild);
    test('Collision with 2 cubes identical', testCollideSameCube);
    test('Collison with 2 cubes on X axis', testCollideCubeX);
    test('No colilson with 2 cubes on X axis', testNoCollideCubeX);
    test('No colilson with 2 cubes on Y axis', testNoCollideCubeY);
  });
}