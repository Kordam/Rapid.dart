part of rapid;

//Define a collider using an oriented bounding box tree
class ObbCollider extends Collider
{
  ObbTree        _tree;

  ObbCollider.empty() : super(ColliderType.OBB) {
    _tree = null;
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
    //Perform larger Obb test
    if (_tree.rootBox.intersectsWithObb3(oth._tree.rootBox) == false)
      return false;


    _tree.leaves.forEach((l) {
      if (l.box.intersectsWithObb3(oth._tree.rootBox)) {
        var idx_li = new List<int>();
        var point_li = new List<Vector3>();
        _findObbContactPoints(oth._tree.root, l, idx_li, point_li);
      }
    });

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