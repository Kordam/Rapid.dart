part of rapid;


Plane Triangle_toPlane(Triangle that)
{
  var v1 = that.point0 - that.point1;
  var v2 = that.point0 - that.point2;
  var normal = v1.cross(v2);
  var d = normal.dot(that.point0); //normal[0] * that.point0[0] + normal[1] * that.point0[1] + normal[2] * that.point0[2];
  return new Plane.normalconstant(normal, d);
}

bool Triangle_intersectWithTriangleBasic(Triangle t1, Triangle t2) {

  //Checking distance to planes
  Plane p1 = Triangle_toPlane(t1);
  Plane p2 = Triangle_toPlane(t2);
  double d0 = p2.distanceToVector3(t1.point0);
  double d1 = p2.distanceToVector3(t1.point1);
  double d2 = p2.distanceToVector3(t1.point2);
  double d3 = p1.distanceToVector3(t2.point0);
  double d4 = p1.distanceToVector3(t2.point1);
  double d5 = p1.distanceToVector3(t2.point2);
  //Trivial reject if all points of t1 are on the same side of t2
  if ((d0 > 0.0 && d1 > 0.0 && d2 > 0.0) || (d0 < 0.0 && d1 < 0.0 && d2 < 0.0)){
    print("p2 false"); return false;
  }
  //Trivial reject if all points of t2 are on the same side of t1
  if ((d3 > 0.0 && d4 > 0.0 && d5 > 0.0) || (d3 < 0.0 && d4 < 0.0 && d5 < 0.0)){
    print("p1 false"); return false;
  }

  //Test t1 edges intersection with t2
  List rays = new List();
  rays.add(new Ray.originDirection(t1.point0, t1.point1 - t1.point0));
  rays.add(new Ray.originDirection(t1.point1, t1.point2 - t1.point1));
  rays.add(new Ray.originDirection(t1.point2, t1.point0 - t1.point2));
  rays.forEach((Ray r) {
    double d = r.intersectsWithTriangle(t2);
    if (d != null && d > 0.0 && d < 1.0)
      return true;
  });

  //Test t2 edges intersection with t1
  rays.clear();
  rays.add(new Ray.originDirection(t2.point0, t2.point1 - t2.point0));
  rays.add(new Ray.originDirection(t2.point1, t2.point2 - t2.point1));
  rays.add(new Ray.originDirection(t2.point2, t2.point0 - t2.point2));
  rays.forEach((Ray r) {
    double d = r.intersectsWithTriangle(t2);
    if (d != null && d > 0.0 && d < 1.0)
      return true;
  });

  return false;
}

/*
  print("Distance p2[${p2.normal}][${p2.constant}] t1 point0[${t1.point0.toString()}] == ${d0}");
  print("Distance p2[${p2.normal}][${p2.constant}] t1 point1[${t1.point1.toString()}] == ${d1}");
  print("Distance p2[${p2.normal}][${p2.constant}] t1 point2[${t1.point2.toString()}] == ${d2}");
  print("Distance p1[${p1.normal}][${p1.constant}] t2 point0[${t2.point0.toString()}] == ${d3}");
  print("Distance p1[${p1.normal}][${p1.constant}] t2 point1[${t2.point1.toString()}] == ${d4}");
  print("Distance p1[${p1.normal}][${p1.constant}] t2 point2[${t2.point2.toString()}] == ${d5}");
 */

//From A fast triangle-triangle intersection test by Tomas Moller
bool Triangle_intersectsWithTriangle(Triangle that, Triangle other)
{
  Plane p2 = Triangle_toPlane(other);
  double d0 = p2.distanceToVector3(that.point0);
  double d1 = p2.distanceToVector3(that.point1);
  double d2 = p2.distanceToVector3(that.point2);
  //Trivial reject if all points of that are on the same side of other
  if ((d0 > 0.0 && d1 > 0.0 && d2 > 0.0) || (d0 < 0.0 && d1 < 0.0 && d2 < 0.0)){
    print("p2 false");
    return false;
  }

  Plane p1 = Triangle_toPlane(that);
  double d3 = p1.distanceToVector3(other.point0);
  double d4 = p1.distanceToVector3(other.point1);
  double d5 = p1.distanceToVector3(other.point2);
  //Trivial reject if all points of other are on the same side of that
  if ((d3 > 0.0 && d4 > 0.0 && d5 > 0.0) || (d3 < 0.0 && d4 < 0.0 && d5 < 0.0)){
    print("p1 false");
    return false;
  }

  //Compute Intersection Line of p1 and p2
  Vector3 line_D = p1.normal.cross(p2.normal);
  print("Line D: ${line_D.toString()}");

  //Compute t1 points projection on line distance
  double proj_0 = line_D.dot(that.point0);
  double proj_1 = line_D.dot(that.point1);
  double proj_2 = line_D.dot(that.point2);
  print("t1 projection on line [${proj_0}][${proj_1}][${proj_2}]");

  //Compute t2 points projection on line distance
  double proj_3 = line_D.dot(other.point0);
  double proj_4 = line_D.dot(other.point1);
  double proj_5 = line_D.dot(other.point2);
  print("t2 projection on line [${proj_3}][${proj_4}][${proj_5}]");

  //Find that intervals with line
  double t1 = proj_0 + (proj_1 - proj_0) * (d0 / (d0 - d1));
  double t2 = proj_0 + (proj_2 - proj_0) * (d0 / (d0 - d2));
  print("T1 intervalues = [${t1}][${t2}]");
  //Find other intervals with line
  double s1 = proj_3 + (proj_4 - proj_3) * (d3 / (d3 - d4));
  double s2 = proj_4 + (proj_5 - proj_4) * (d4 / (d4 - d5));
  print("T2 intervalues = [${s1}][${s2}]");

  //Return intervals overlap test
  //Source: GPGPU Programming for Games and Science By David H. Eberly
  return (max(s1, s2) > min(t1, t2) && max(t1, t2) > min(s1, s2)) ? true : false;
}