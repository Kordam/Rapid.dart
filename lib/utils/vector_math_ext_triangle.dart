part of rapid;


Plane Triangle_toPlane(Triangle that)
{
  var v1 = that.point2 - that.point0;
  var v2 = that.point1 - that.point0;
  var normal = v1.cross(v2);
  var d = normal[0] * that.point0[0] + normal[1] * that.point0[1] + normal[2] * that.point0[2];
  return new Plane.normalconstant(normal, d);
}

//From A fast triangle-triangle intersection test by Tomas Moller
bool Triangle_intersectsWithTriangle(Triangle that, Triangle other)
{
  Plane p2 = Triangle_toPlane(other);
  double d0 = p2.distanceToVector3(that.point0);
  double d1 = p2.distanceToVector3(that.point1);
  double d2 = p2.distanceToVector3(that.point2);
  //Trivial reject if all points of that are on the same side of other
  if ((d0 > 0.0 && d1 > 0.0 && d2 > 0.0) || (d0 < 0.0 && d1 < 0.0 && d2 < 0.0)){
    return false;
  }

  Plane p1 = Triangle_toPlane(that);
  double d3 = p1.distanceToVector3(other.point0);
  double d4 = p1.distanceToVector3(other.point1);
  double d5 = p1.distanceToVector3(other.point2);
  //Trivial reject if all points of other are on the same side of that
  if ((d3 > 0.0 && d4 > 0.0 && d5 > 0.0) || (d3 < 0.0 && d4 < 0.0 && d5 < 0.0)){
    return false;
  }

  //Compute Intersection Line of p1 and p2
  Vector3 line_D = p1.normal.cross(p2.normal);

  //Compute t1 points projection on line distance
  double proj_0 = line_D.dot(that.point0);
  double proj_1 = line_D.dot(that.point1);
  double proj_2 = line_D.dot(that.point2);
  //Compute t2 points projection on line distance
  double proj_3 = line_D.dot(that.point0);
  double proj_4 = line_D.dot(that.point1);
  double proj_5 = line_D.dot(that.point2);

  //Find that intervals with line
  double t1 = proj_0 + (proj_1 - proj_0) * (d0 / (d0 - d1));
  double t2 = proj_1 + (proj_2 - proj_1) * (d1 / (d1 - d2));
  //Find other intervals with line
  double s1 = proj_3 + (proj_4 - proj_3) * (d3 / (d3 - d4));
  double s2 = proj_1 + (proj_5 - proj_4) * (d4 / (d4 - d5));

  //Return intervals overlap test
  //Source: GPGPU Programming for Games and Science By David H. Eberly
  return (max(s1, s2) > min(t1, t2) && max(t1, t2) > min(s1, s2));
}