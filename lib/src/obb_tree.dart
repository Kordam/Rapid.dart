part of rapid;

//Define an oriented bounding box tree data structure
class ObbTree
{
  List<Obb3> _boxes;

  //Construct an ObbTree
  ObbTree.fromPoints(List<Vector3D> points, int divide)
  {
    Obb3 box = Obb3_fitFromPoints(points);
  }

}