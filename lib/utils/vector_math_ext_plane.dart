part of rapid;

//Split a list of [points] in [left] and [right] list
//according to the [plane]
bool Plane_separatePoints(Plane p, List<Vector3> points, List<Vector3> left, List<Vector3> right)
{
  if (points.length == 0)
    return false;
  points.forEach((point) {
    if (p.distanceToVector3(point) > 0.0) {
      left.add(point);
    }
    else {
      right.add(point);
    }
  });
  return true;
}

//Split a list of [tris] integers in [points] according to the plane [p].
//The [left_tris] and [right_tris] integers list are filled
//with new indexes relative the [left_points] and [right_points] lists respectively
bool Plane_separateTris(Plane p, List<Vector3> points, List<int> tris,
                        List<Vector3> left_points, List<Vector3> right_points,
                        List<int> left_tris, List<int> right_tris)
{
  if (points.length == 0 || tris.length == 0)
    return false;

  //Iterate over triangles [tris]
  for (var i = 0; i < tris.length; i += 3) {
    var point = [ points[tris[i + 0]], //p1, p2, p3
                  points[tris[i + 1]],
                  points[tris[i + 2]]];
    var n_left = 0;

    //Compute distance to plane
    var d0 = p.distanceToVector3(point[0]);
    var d1 = p.distanceToVector3(point[1]);
    var d2 = p.distanceToVector3(point[2]);

    //Count nb points on the left side of the plane
    d0 >= 0.0 ? n_left += 1 : n_left += 0;
    d1 >= 0.0 ? n_left += 1 : n_left += 0;
    d2 >= 0.0 ? n_left += 1 : n_left += 0;

    //Most of the points are left
    if (n_left >= 2) {
      //push points left
      for (var j = 0; j < 3; j++)
      {
        var idx = left_points.indexOf(point[j]);
        if (idx != -1)
          left_tris.add(idx);
        else {
          left_points.add(point[j]);
          left_tris.add(left_points.indexOf(point[j]));
        }
      }
    }
    else { // Most of the points are right
      //push point right
      for (var j = 0; j < 3; j++)
      {
        var idx = right_points.indexOf(point[j]);
        if (idx != -1)
          right_tris.add(idx);
        else {
          right_points.add(point[j]);
          right_tris.add(right_points.indexOf(point[j]));
        }
      }
    }
  }
  return true;
}

/* Plane line intersection
  //Compute Intersection Line of p1 and p2
  var line_D = p1.normal.cross(p2.normal);
  var line_O = new Vector3.zero();
  var det;
  if (line_D[0] != 0.0) { // let x = 0, solve for y, z
    det = p1.normal[1] * p2.normal[2] - p1.normal[2] * p2.normal[1];
    line_O[0] = 0.0;
    line_O[1] = (p2.normal[2] * p1.constant - p1.normal[2] * p2.constant) / det;
    line_O[2] = (-p2.normal[1] * p1.constant + p1.normal[1] * p2.constant) / det;
  }
  else if (line_D[1] != 0.0) { // let y = 0, solve for x, z
    det = p1.normal[0] * p2.normal[2] - p1.normal[2] * p2.normal[0];
    line_O[0] = (p2.normal[2] * p1.constant - p1.normal[2] * p2.constant) / det;
    line_O[1] = 0.0;
    line_O[2] = (-p2.normal[0] * p1.constant + p1.normal[0] * p2.constant) / det;
  }
  else if (line_D[2] != 0.0) { // let z = 0, solve for x, y
      det = p1.normal[0] * p2.normal[1] - p1.normal[1] * p2.normal[0];
      line_O[0] = (p2.normal[1] * p1.constant - p1.normal[1] * p2.constant) / det;
      line_O[1] = (-p2.normal[0] * p1.constant + p1.normal[0] * p2.constant) / det;
      line_O[2] = 0.0;
    }
  else { //Planes are parallel
      return false;
    }
*/