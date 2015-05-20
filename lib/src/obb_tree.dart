part of rapid;

//Define an oriented bounding box tree data structure
class ObbTree
{
  List<Obb3> _boxes = new List<Obb3>();

  //Construct an ObbTree
  ObbTree.fromPoints(List<Vector3> points, int divide)
  {
    Obb3 box = Obb3_fitFromPoints(points);
    _boxes.add(box);
  }

  get boxes => _boxes;
}