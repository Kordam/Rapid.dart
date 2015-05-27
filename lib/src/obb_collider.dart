part of rapid;

//Define a collider using an oriented bounding box tree
class ObbCollider extends Collider
{
  ObbTree        _tree;

  ObbCollider.empty() : super(ColliderType.OBB) {
    _tree = null;
  }

  ObbCollider.fromVertices(List<Vector3> vertices, {split: 1}) : super(ColliderType.OBB)
  {
    _tree = new ObbTree.fromPoints(vertices, split);
  }

  ObbCollider.fromTriangles(List<int> tris, List<Vector3> vertices, {split: 1}): super(ColliderType.OBB)
  {
    _tree = new ObbTree.fromTriangles(tris, vertices, 4);
  }

  //Getters and setters
  get center => _tree.root.centroid;
  get tree => _tree;

  //Check if current ObbCollider collide with another ObbCollider,
  //If so, Lists of colliding [points] and faces [idx] can be filled
  bool collideWithObb(ObbCollider oth, {List<int> idx: null, List<Vector3> points: null})
  {
    return false;
  }

  //Check if current ObbCollider collide with an AbbCollider,
  //If so, Lists of colliding [points] and faces [idx] can be filled
  bool collideWithAbb(ObbCollider oth, {List<int> idx: null, List<Vector3> points: null}) {
    return false;
  }

  //Check if current ObbCollider collide with a SphereCollider,
  //If so, Lists of colliding [points] and faces [idx] can be filled
  bool collideWithSphere(ObbCollider oth, {List<int> idx: null, List<Vector3> points: null}) {
    return false;
  }

}