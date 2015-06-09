part of rapid;

//Define a node within a binary data tree
class ObbTreeNode
{
  int   depth;
  bool  leaf;
  ObbTreeNode left;
  ObbTreeNode right;

  //Node data
  Obb3          box;
  List<Vector3> points;
  List<int>     tris;
  Vector3       centroid;

  ObbTreeNode(this.box, this.points, this.tris, this.centroid,
              {this.depth: 0, this.leaf: false,
              this.left: null, this.right: null});

  bool intersectWith(ObbTreeNode oth) {
    return box.intersectsWithObb3(oth.box);
  }
}

//Define an oriented bounding box tree data structure
class ObbTree
{
  ObbTreeNode       _root;
  List<ObbTreeNode> _leaf;

  //Construct on ObbTree from a list of [tris] indexes in [points] list
  ObbTree.fromTriangles(List<int> tris, List<Vector3> points, int divide) {
    Vector m = new Vector3.zero();
    Obb3 box = Obb3_fitFromTriangles(tris, points, mean: m);

    _leaf = new List();
    _root = new ObbTreeNode(box, points, tris, m, depth: 0, leaf: true);
    if (divide >= 1) {
      _splitTriangles(_root, 1, divide);
      _root.leaf = false;
      _root.points = null;  //Clear points after subdivision
      _root.tris = null;  //Clear tris after subdivision
    }
  }

  //Recursive method that splits the [parent] node
  //on the longest axis of [node]
  //by filling the left an right child nodes
  void _splitTriangles(ObbTreeNode parent, int currentDepth, int maxDepth)
  {
    var p = Obb3_splitPlane(parent.box, parent.centroid);
    print("Triangles split Depth ${currentDepth} Centroid ${parent.centroid.toString()} Plane normal ${p.normal}}");

    //Sort tris and points
    List<int> left_tris = new List<int>();
    List<int> right_tris = new List<int>();
    List<Vector3> left_points = new List<Vector3>();
    List<Vector3> right_points  = new List<Vector3>();
    Plane_separateTris(p, parent.points, parent.tris, left_points, right_points, left_tris, right_tris);

    //Allocate Left part
    ObbTreeNode left = null;
    if (left_points.length > 0) {
      print("Depth ${currentDepth} as ${left_points.length} left tris");
      Vector3 left_mean = new Vector3.zero();
      Obb3 left_box = Obb3_fitFromTriangles(left_tris, left_points, mean: left_mean);
      left = new ObbTreeNode(left_box, left_points, left_tris, left_mean, depth: currentDepth);
    }

    //Allocate right part
    ObbTreeNode right = null;
    if (right_points.length > 0) {
      print("Depth ${currentDepth} as ${right_points.length} right tris");
      Vector3 right_mean = new Vector3.zero();
      Obb3 right_box = Obb3_fitFromTriangles(right_tris, right_points, mean: right_mean);
      right = new ObbTreeNode(right_box, right_points, right_tris, right_mean, depth: currentDepth);
    }

    //Assign parent node left & right
    parent.left = left;
    parent.right = right;

    currentDepth++;
    if (currentDepth > maxDepth) {
      if (left != null) {
        parent.left.leaf = true;
        _leaf.add(parent.left);
      }
      if (right != null) {
        parent.right.leaf = true;
        _leaf.add(parent.right);
      }
      return;
    }
    else {
      if (left != null) {
        _splitTriangles(parent.left, currentDepth, maxDepth);
        parent.left.points = null; //Clear points after subdivision
      }
      if (right != null) {
        _splitTriangles(parent.right, currentDepth, maxDepth);
        parent.right.points = null; //Clear points after subdivision
      }
    }
  }

  get root => _root;
  get rootBox => _root.box;
  get leaves => _leaf;
}