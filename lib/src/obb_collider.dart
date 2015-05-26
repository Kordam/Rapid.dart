part of rapid;

//Define a collider using an oriented bounding box
class ObbCollider
{
  ObbTree        _tree;

  ObbCollider.empty() {
    _tree = null;
  }

  ObbCollider.fromVertices(List<Vector3> vertices, {split: 4})
  {
    _tree = new ObbTree.fromPoints(vertices, split);
  }

  ObbCollider.fromTriangles(List<int> tris, List<Vector3> vertices, {split: 4})
  {
    _tree = new ObbTree.fromTriangles(tris, vertices, 4);
  }
}