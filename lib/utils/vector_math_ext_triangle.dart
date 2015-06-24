part of rapid;

//Compute plane containing [that]
Plane Triangle_toPlane(Triangle that)
{
  var v1 = that.point1 - that.point0;
  var v2 = that.point2 - that.point0;
  var normal = v1.cross(v2);
  normal.x = NEAR_ZERO(normal.x);
  normal.y = NEAR_ZERO(normal.y);
  normal.z = NEAR_ZERO(normal.z);
  normal *= 1.0 / sqrt(normal.x * normal.x + normal.y * normal.y + normal.z * normal.z);
  var d = NEAR_ZERO( - (normal[0] * that.point0[0] + normal[1] * that.point0[1] + normal[2] * that.point0[2]) );
  return new Plane.normalconstant(normal, d);
}

//Return if [that] intersects with [other]
//From A fast triangle-triangle intersection test by Tomas Moller
bool Triangle_intersectsWithTriangle(Triangle that, Triangle other)
{
  Plane p1 = Triangle_toPlane(that);
  Plane p2 = Triangle_toPlane(other);
  double d0 = p2.distanceToVector3(that.point0);
  double d1 = p2.distanceToVector3(that.point1);
  double d2 = p2.distanceToVector3(that.point2);
  double d3 = p1.distanceToVector3(other.point0);
  double d4 = p1.distanceToVector3(other.point1);
  double d5 = p1.distanceToVector3(other.point2);
  //Trivial reject if all points of that are on the same side of other
  if ((d0 > 0.0 && d1 > 0.0 && d2 > 0.0) || (d0 < 0.0 && d1 < 0.0 && d2 < 0.0)){
    return false;
  }
  //Trivial reject if all points of other are on the same side of that
  if ((d3 > 0.0 && d4 > 0.0 && d5 > 0.0) || (d3 < 0.0 && d4 < 0.0 && d5 < 0.0)){
    return false;
  }
  //Handle coplanar triangles
  if (d0 == 0.0 && d1 == 0.0 && d2 == 0.0){
    return Triangle_intersectsWithCoplanarTriangle(that, other);
  }

  //Compute Intersection Line of p1 and p2
  Vector3 line_D = p1.normal.cross(p2.normal);
  //Compute t1 points projection on line distance
  double proj_0 = line_D.dot(that.point0);
  double proj_1 = line_D.dot(that.point1);
  double proj_2 = line_D.dot(that.point2);
  //Compute t2 points projection on line distance
  double proj_3 = line_D.dot(other.point0);
  double proj_4 = line_D.dot(other.point1);
  double proj_5 = line_D.dot(other.point2);

  //Find that intervals with line
  double t1 = proj_0 + (proj_1 - proj_0) * (d0 / (d0 - d1));
  double t2 = proj_0 + (proj_2 - proj_0) * (d0 / (d0 - d2));

  //Find other intervals with line
  double s1 = proj_3 + (proj_4 - proj_3) * (d3 / (d3 - d4));
  double s2 = proj_4 + (proj_5 - proj_4) * (d4 / (d4 - d5));

  //Return intervals overlap test
  //Source: GPGPU Programming for Games and Science By David H. Eberly
  return (max(s1, s2) > min(t1, t2) && max(t1, t2) > min(s1, s2)) ? true : false;
}

//Return if [other] coplanar triangle intersects with [that]
bool Triangle_intersectsWithCoplanarTriangle(Triangle that, Triangle other) {
  var that_edges = new List();
  var other_edges = new List();
  that_edges.add(new Vector2(that.point0.x, that.point0.y));
  that_edges.add(new Vector2(that.point1.x - that.point0.x, that.point1.y - that.point0.y));
  that_edges.add(new Vector2(that.point1.x, that.point1.y));
  that_edges.add(new Vector2(that.point2.x - that.point1.x, that.point2.y - that.point1.y));
  that_edges.add(new Vector2(that.point2.x, that.point2.y));
  that_edges.add(new Vector2(that.point0.x - that.point2.x, that.point0.y - that.point2.y));

  other_edges.add(new Vector2(other.point0.x, other.point0.y));
  other_edges.add(new Vector2(other.point1.x - other.point0.x, other.point1.y - other.point0.y));
  other_edges.add(new Vector2(other.point1.x, other.point1.y));
  other_edges.add(new Vector2(other.point2.x - other.point1.x, other.point2.y - other.point1.y));
  other_edges.add(new Vector2(other.point2.x, other.point2.y));
  other_edges.add(new Vector2(other.point0.x - other.point2.x, other.point0.y - other.point2.y));

  for (int i = 0; i < that_edges.length; i += 2) {
    var p = that_edges[i];
    var r = that_edges[i + 1];
    for (int j = 0; j < other_edges.length; j += 2) {
      var q = other_edges[j];
      var s = other_edges[j + 1];
      if (Triangle_Private_edgeIntersectsWithEdge(p, r, q, s) == true) {
        return true;
      }
    }
  }
  return false;
}

bool Triangle_Private_edgeIntersectsWithEdge(Vector2 p, Vector2 r, Vector2 q, Vector2 s) {
  double t = (q - p).cross(s) / (r.cross(s));
  double u = (q - p).cross(r) / (r.cross(s));

  if (r.cross(s) == 0.0 && (q - p).cross(r) == 0.0) {
    double t0 = (q - p).dot(r) / (r.dot(r));
    double t1 = t0 + s.dot(r) / (r.dot(r));
    return (min(t0, t1) <= 0.0 && max(t0, t1) >= 0.0) || (min(t0, t1) <= 1.0 && max(t0, t1) >= 1.0);
  }
  if (r.cross(s) != 0.0 && (t >= 0.0 && t <= 1.0) && (u >= 0.0 && u <= 0.0)) {
    return true;
  }
  return false;
}



//Return if [that] intersects with [other]
//This is less efficient than intersectsWithTriangle
bool Triangle_intersectsWithTriangleBasic(Triangle t1, Triangle t2) {

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
    return false;
  }
  //Trivial reject if all points of t2 are on the same side of t1
  if ((d3 > 0.0 && d4 > 0.0 && d5 > 0.0) || (d3 < 0.0 && d4 < 0.0 && d5 < 0.0)){
    return false;
  }
  //Handle coplanar triangles
  if (d0 == 0.0 && d1 == 0.0 && d2 == 0.0){
    return Triangle_intersectsWithCoplanarTriangle(t1, t2);
  }

  //Test t1 edges intersection with t2
  List rays = new List();
  bool inter = false;
  rays.add(new Ray.originDirection(t1.point0, t1.point1 - t1.point0));
  rays.add(new Ray.originDirection(t1.point1, t1.point2 - t1.point1));
  rays.add(new Ray.originDirection(t1.point2, t1.point0 - t1.point2));
  rays.forEach((Ray r) {
    double d = r.intersectsWithTriangle(t2);
    if (d != null && d >= 0.0 && d < 1.0) {
      inter = true;
    }
  });
  if (inter == true)
    return true;

  //Test t2 edges intersection with t1
  rays.clear();
  rays.add(new Ray.originDirection(t2.point0, t2.point1 - t2.point0));
  rays.add(new Ray.originDirection(t2.point1, t2.point2 - t2.point1));
  rays.add(new Ray.originDirection(t2.point2, t2.point0 - t2.point2));
  rays.forEach((Ray r) {
    double d = r.intersectsWithTriangle(t1);
    if (d != null && d >= 0.0 && d < 1.0)
      inter = true;
  });

  return inter;
}
/*
  print("Distance p2[${p2.normal}][${p2.constant}] t1 point0[${t1.point0.toString()}] == ${d0}");
  print("Distance p2[${p2.normal}][${p2.constant}] t1 point1[${t1.point1.toString()}] == ${d1}");
  print("Distance p2[${p2.normal}][${p2.constant}] t1 point2[${t1.point2.toString()}] == ${d2}");
  print("Distance p1[${p1.normal}][${p1.constant}] t2 point0[${t2.point0.toString()}] == ${d3}");
  print("Distance p1[${p1.normal}][${p1.constant}] t2 point1[${t2.point1.toString()}] == ${d4}");
  print("Distance p1[${p1.normal}][${p1.constant}] t2 point2[${t2.point2.toString()}] == ${d5}");
 */
