library rapid.test.utils;

import 'package:unittest/unittest.dart';
import 'package:rapid/rapid.dart';
import 'package:vector_math/vector_math.dart';

void trianglesIntersectionFail1() {
  Triangle tri1 = new Triangle.points(new Vector3(0.0, 0.0, 0.0), new Vector3(0.0, 1.0, 1.0), new Vector3(0.0, 0.5, 2.0));
  Triangle tri2 = new Triangle.points(new Vector3(1.0, 0.0, 0.0),  new Vector3(3.0, 1.0, 0.0), new Vector3(5.0, 0.5, 0.0));
  expect(Triangle_intersectsWithTriangle(tri1, tri2), false);
}

void trianglesIntersectionFail2() {
  Triangle tri1 = new Triangle.points(new Vector3(0.0, 0.0, 0.0), new Vector3(0.0, 1.0, 0.0), new Vector3(0.0, 0.5, 2.0));
  Triangle tri2 = new Triangle.points(new Vector3(1.0, 0.0, 0.0),  new Vector3(1.0, 1.0, 0.0), new Vector3(2.0, 0.5, 2.0));
  expect(Triangle_intersectsWithTriangle(tri1, tri2), false);
}

void trianglesIntersectionCase1() {
  Triangle tri1 = new Triangle.points(new Vector3(-2.0, 0.0, 0.0), new Vector3(0.0, 0.0, 3.0), new Vector3(2.0, 0.0, 0.0));
  Triangle tri2 = new Triangle.points(new Vector3(-1.0, -1.0, 1.0),  new Vector3(0.0, 1.0, 1.0), new Vector3(1.0, -1.0, 1.0));
  expect(Triangle_intersectsWithTriangle(tri1, tri2), true);
}

void trianglesIntersectionCase2() {
  Triangle tri1 = new Triangle.points(new Vector3(-1.0, 0.0, 0.0), new Vector3(0.0, 0.0, 2.0), new Vector3(1.0, 0.0, 0.0));
  Triangle tri2 = new Triangle.points(new Vector3(-4.0, -1.0, 1.0),  new Vector3(0.0, 2.0, 0.0), new Vector3(4.0, -1.0, 1.0));
  expect(Triangle_intersectsWithTriangle(tri1, tri2), true);
}

void trianglesIntersectionCase3() {
  Triangle tri1 = new Triangle.points(new Vector3(0.0, 0.0, 0.0), new Vector3(0.0, 0.0, 0.0), new Vector3(0.0, 0.0, 0.0));
  Triangle tri2 = new Triangle.points(new Vector3(0.0, 0.0, 0.0),  new Vector3(0.0, 0.0, 0.0), new Vector3(0.0, 0.0, 0.0));
  expect(Triangle_intersectsWithTriangle(tri1, tri2), true);
}


void main()
{
  group("Vector math extension utils", () {
    test("Triangles intersections fail1", trianglesIntersectionFail1);
    test("Triangles intersections fail2", trianglesIntersectionFail2);
    test("Triangles intersections case1", trianglesIntersectionCase1);
    test("Triangles intersections case2", trianglesIntersectionCase2);
    test("Triangles intersections case3", trianglesIntersectionCase3);
    //test("Triangles intersections coplanar", trianglesintersectioncoplanar);
    //test("Triangles are coplanar", trianglesAreCoplanar);
  });
}