part of rapid;

//Define a collider using an oriented bounding box tree
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

  //Check if current ObbCollider collide with another ObbCollider,
  //If so, Lists of colliding [points] and faces [idx] can be filled
  bool collideWith(ObbCollider oth, {List<int> idx: null, List<Vector3> points: null})
  {
    return false;
  }
}