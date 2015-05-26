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

  for (var i = 0; i < tris.length; i += 3) {
    var point = [ points[tris[i + 0]],
                  points[tris[i + 1]],
                  points[tris[i + 2]]];
    var dist = p.distanceToVector3(point[0]) +
               p.distanceToVector3(point[1]) +
               p.distanceToVector3(point[2]);
    if (dist >= 0.0) {
      for (var j = 0; j < 3; j++)
      {
        var idx = left_points.lastIndexOf(point[j]);
        if (idx != -1)
          left_tris.add(idx);
        else {
          left_points.add(point[j]);
          left_tris.add(left_points.lastIndexOf(point[j]));
        }
      }
    }
    else {
      for (var j = 0; j < 3; j++)
      {
        var idx = right_points.lastIndexOf(point[j]);
        if (idx != -1)
          right_tris.add(idx);
        else {
          right_points.add(point[j]);
          right_tris.add(left_points.lastIndexOf(point[j]));
        }
      }
    }
  }
  return true;
}