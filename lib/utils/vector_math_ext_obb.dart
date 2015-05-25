part of rapid;

const double EPSILON = 1e-5;

//Sort the axis of an [obb] by size
List<Vector3> Obb3_sortAxis(Obb3 obb)
{
  var cmp = new Vector3.zero();
  var res = new List<Vector3>();
  res.add(obb.axis0);
  res.add(obb.axis1);
  res.add(obb.axis2);
  res.sort((a, b) {
   Vector3.min(a, b, cmp);
    if (cmp == a)
      return -1;
    return 1;
  });
  return res;
}


//Compute a plane that splits a [box] and pass by [point]
//If the [box] is considered to be inseparable,
//this function should throw an exception.
Plane Obb3_splitPlane(Obb3 box, Vector3 point)
{
  var li = Obb3_sortAxis(box);
  var axis = null;
  //Chose the first axis that works
  if (li[0].normalized().dot(point.normalized()) != 0.0) {
    axis = li[0];
  }
  else if (li[1].normalized().dot(point.normalized()) != 0.0) {
    axis = li[1];
  }
  else if (li[2].normalized().dot(point.normalized()) != 0.0) {
    axis = li[2];
  }
  else {
      throw new SplitBoxException("No axis found to split at ${point.toString()}");
  }

  var d = axis[0] * point[0] + axis[1] * point[1] + axis[2] * point[2];
  var p = new Plane.normalconstant(axis, d);
  return p;
}

//Construct an obb3 from a covariance matrix [cov]and a list of [points]
Obb3 Obb3_fitFromCovarianceMatrix(Matrix3 cov, List<Vector3> points)
{
  Matrix3 rot = new Matrix3.zero();
  Matrix3 eigvec = new Matrix3.zero();
  Vector3 eigval = new Vector3.zero();

  Matrix3_compute_symmetric_eigen(cov, eigvec, eigval);

  Vector3 r = new Vector3(eigvec.getRow(0)[0], eigvec.getRow(1)[0], eigvec.getRow(2)[0]);
  Vector3 u = new Vector3(eigvec.getRow(0)[1], eigvec.getRow(1)[1], eigvec.getRow(2)[1]);
  Vector3 f = new Vector3(eigvec.getRow(0)[2], eigvec.getRow(1)[2], eigvec.getRow(2)[2]);
  r.normalize(); u.normalize(); f.normalize();

  rot.setEntry(0, 0, r.x); rot.setEntry(0, 1, u.x); rot.setEntry(0, 2, f.x);
  rot.setEntry(1, 0, r.y); rot.setEntry(1, 1, u.y); rot.setEntry(1, 2, f.y);
  rot.setEntry(2, 0, r.z); rot.setEntry(2, 1, u.z); rot.setEntry(2, 2, f.z);

  Vector3 minim = new Vector3(1e10, 1e10, 1e10);
  Vector3 maxim = new Vector3(-1e10, -1e10, -1e10);
  Vector3 prime = new Vector3.zero();
  points.forEach((p) {
    prime.setValues(r.dot(p), u.dot(p), f.dot(p));
    Vector3.min(minim, prime, minim);
    Vector3.max(maxim, prime, maxim);
  });

  Vector3 center = (minim + maxim) * 0.5;
  Vector3 pos = new Vector3(rot.getRow(0).dot(center), rot.getRow(1).dot(center), rot.getRow(2).dot(center));
  Obb3 box = new Obb3.centerExtentsAxes(center, (maxim - minim) * 0.5, rot.getRow(0), rot.getRow(1), rot.getRow(2));
  return box;
}

//Construct an Obb3 from a list of integers triangles [indices]
//and associated [points], the centroid will be stored in [mean]
//if provided
Obb3 Obb3_fitFromTriangles(List<int> indices, List<Vector3> points, {Vector3 mean : null})
{
  double Ai = 0.0;
  double Am =0.0;
  Vector3 mu = new Vector3.zero();
  Vector3 mui = new Vector3.zero();
  Matrix3 cov = new Matrix3.zero();
  Vector3 m = new Vector3.zero();
  double cxx=0.0, cxy=0.0, cxz=0.0, cyy=0.0, cyz=0.0, czz=0.0;

  //Find the mean point
  points.forEach((p) => m += p);
  m /= points.length.toDouble();
  if (mean != null)
    m.copyInto(mean);

  // loop over the triangles this time to find the
  // mean location
  for(var i=0; i < indices.length; i+=3 )
  {
    Vector3 p = points[indices[i+0]];
    Vector3 q = points[indices[i+1]];
    Vector3 r = points[indices[i+2]];
    mui = (p+q+r)/3.0;
    Ai = (q-p).cross(r-p).normalizeLength() / 2.0;
    mu += mui*Ai;
    Am += Ai;

    // these bits set the c terms to Am*E[xx], Am*E[xy], Am*E[xz]....
    cxx += ( 9.0*mui.x*mui.x + p.x*p.x + q.x*q.x + r.x*r.x )*(Ai/12.0);
    cxy += ( 9.0*mui.x*mui.y + p.x*p.y + q.x*q.y + r.x*r.y )*(Ai/12.0);
    cxz += ( 9.0*mui.x*mui.z + p.x*p.z + q.x*q.z + r.x*r.z )*(Ai/12.0);
    cyy += ( 9.0*mui.y*mui.y + p.y*p.y + q.y*q.y + r.y*r.y )*(Ai/12.0);
    cyz += ( 9.0*mui.y*mui.z + p.y*p.z + q.y*q.z + r.y*r.z )*(Ai/12.0);
  }
  // divide out the Am fraction from the average position and
  // covariance terms
  mu /= Am;
  cxx /= Am; cxy /= Am; cxz /= Am; cyy /= Am; cyz /= Am; czz /= Am;

  // now subtract off the E[x]*E[x], E[x]*E[y], ... terms
  cxx -= mu.x*mu.x; cxy -= mu.x*mu.y; cxz -= mu.x*mu.z;
  cyy -= mu.y*mu.y; cyz -= mu.y*mu.z; czz -= mu.z*mu.z;

  // now build the covariance matrix
  cov.setValues(cxx, cxy, cxz,
                cxy, cyy, cyz,
                cxz, cyz, czz);

  return Obb3_fitFromCovarianceMatrix(cov, points);
}

//Construct an Obb3 from a list of [points],
//the centroid point will be stored in [mean]if provided
Obb3 Obb3_fitFromPoints(List<Vector3> points, {Vector3 mean : null})
{
  Vector3 m = new Vector3(0.0, 0.0, 0.0);
  Matrix3 cov = new Matrix3.zero();

  //Find the mean point
  points.forEach((p) => m += p);
  m /= points.length.toDouble();
  if (mean != null)
    m.copyInto(mean);

  //Compute the covariance matrix
  double cxx = 0.0, cxy = 0.0, cxz = 0.0,
         cyy = 0.0, cyz = 0.0, czz = 0.0;
  points.forEach((p) {
    cxx += p[0] * p[0] - m[0] * m[0];
    cxy += p[0] * p[1] - m[0] * m[1];
    cxz += p[0] * p[2] - m[0] * m[2];
    cyy += p[1] * p[1] - m[1] * m[1];
    cyz += p[1] * p[2] - m[1] * m[2];
    czz += p[2] * p[2] - m[2] * m[2];
  });

  cov.setValues(cxx, cxy, cxz,
  cxy, cyy, cyz,
  cxz, cyz, czz);

  return Obb3_fitFromCovarianceMatrix(cov, points);
}