part of rapid;

//Define a collider using an oriented bounding box tree
class ObbCollider extends Collider
{
  ObbTree        _tree;

  ObbCollider.empty() : super(ColliderType.OBB) {
    _tree = null;
  }

  ObbCollider.fromTriangles(List<int> tris, List<Vector3> vertices, {split: 4}): super(ColliderType.OBB)
  {
    _tree = new ObbTree.fromTriangles(tris, vertices, split);
  }


  void translate(Vector3 vec) {
    _tree.translate(vec);
  }

  //Rotate by the given euleur [angles]
  void rotate(Vector3 angles) {
    _tree.rotate(angles);
  }

  //Getters and setters
  get center => _tree.root.centroid;
  get tree => _tree;

  //Check if current ObbCollider collide with another ObbCollider,
  //If so, Lists of colliding [points] and faces [idx] can be filled
  bool collideWithObb(ObbCollider oth, {List<int> idx: null, List<Vector3> points: null})
  {
    var li = idx;
    var p= points;

    //Perform larger Obb test
    if (_tree.rootBox.intersectsWithObb3(oth._tree.rootBox) == false)
      return false;
    //Allocate lists if not given
    if (li == null) {
      li = new List();
    }
    if (p == null) {
      p = new List();
    }
    //Perform recursive test from root nodes
    return _collideWithObb(_tree.root, oth._tree.root, li, p);
  }

  //Perform a recursive collision test between nodes
  bool _collideWithObb(ObbTreeNode a, ObbTreeNode b, List<int> idx, List<Vector3> points) {
    if (a == null || b == null) {
      return false;
    }
    if (a.leaf && b.leaf) {
      return a.getTriangleCollision(b, idx, points);
    }
    if (a.box.intersectsWithObb3(b.box)) {
      var res = false;
      if (a.depth <= b.depth) {
        res = _collideWithObb(a.left, b, idx, points) || _collideWithObb(a.right, b, idx, points);
      }
      else {
        res = _collideWithObb(a, b.left, idx, points) || _collideWithObb(a, b.right, idx, points);
      }
      return res;
    }
    return false;
  }


  bool _findObbContactPoints(ObbTreeNode root, ObbTreeNode node, List<int> idx, List<Vector3> points) {
    //Recurse to leave that intersect
    if (root.leaf == false) {
      if (root.left != null && node.box.intersectsWithObb3(root.left.box)) {
        _findObbContactPoints(root.left, node, idx, points);
      }
      if (root.right != null && node.box.intersectsWithObb3(root.right.box)) {
        _findObbContactPoints(root.left, node, idx, points);
      }
    }
    else { //Leaf intersects with node

    }
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