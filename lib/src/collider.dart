part of rapid;

//Define a collider using an oriented bounding box
class Collider
{
  ObbTree        bounds;
  List<Vector3>  vertices;

  Collider.empty()
  {
    bounds = null;
    vertices = new List<Vector3>();
  }

  Collider.fromVertices(List<Vector3> v)
  {
    vertices = v;
    bounds = new ObbTree.fromPoints(vertices, 0);
  }
}