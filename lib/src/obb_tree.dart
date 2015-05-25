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
}

//Define an oriented bounding box tree data structure
class ObbTree
{
  ObbTreeNode _root;

  //Construct an ObbTree from a list of points
  ObbTree.fromPoints(List<Vector3> points, int divide)
  {
    Vector m = new Vector3.zero();
    Obb3 box = Obb3_fitFromPoints(points, mean: m);

    _root = new ObbTreeNode(box, points, null, m, depth: 1, leaf: true);
    if (divide >= 1) {
      _splitPoints(_root, 1, divide);
      _root.leaf = false;
      _root.points.clear(); //Clear points after subdivision
      _root.points = null;
    }
  }

  //Construct on ObbTree from a list of [tris] indexes in [points] list
  ObbTree.fromTriangles(List<int> tris, List<Vector3> points, int divide) {
    Vector m = new Vector3.zero();
    Obb3 box = Obb3_fitFromTriangles(tris, points, mean: m);

    _root = new ObbTreeNode(box, points, tris, m, depth: 1, leaf: true);
    if (divide >= 1) {
      _splitTriangle(_root, m, 1, divide);
      _root.leaf = false;
    }
  }


  //Recursive method that splits the [parent] node
  //on the longest axis of [node] and the point [mean]
  //by filling the left an right child nodes
  void _splitPoints(ObbTreeNode parent, int currentDepth, int maxDepth)
  {
    var p = Obb3_splitPlane(parent.box, parent.centroid);
    print("Plane normal ${p.normal}}");

    //TODOOOOO
    //Sort points
    List<Vector3> left_points = new List<Vector3>();
    List<Vector3> right_points  = new List<Vector3>();

    //Allocate Left part
    Vector3 left_mean = new Vector3.zero();
    Obb3 left_box = Obb3_fitFromPoints(left_points, mean: left_mean);
    ObbTreeNode left = new ObbTreeNode(left_box, left_points, null, left_mean, depth: currentDepth);

    //Allocate right part
    Vector3 right_mean = new Vector3.zero();
    Obb3 right_box = Obb3_fitFromPoints(right_points, mean: right_mean);
    ObbTreeNode right = new ObbTreeNode(right_box, right_points, null, right_mean, depth: currentDepth);


    //Assign parent node left & right
    parent.left = left;
    parent.right = right;

    currentDepth++;
    if (currentDepth > maxDepth) {
      parent.left.leaf = true;
      parent.right.leaf = true;
      return;
    }
    else {
      _splitPoints(parent.left, currentDepth, maxDepth);
      parent.left.points = null; //Clear points after subdivision
      _splitPoints(parent.right, currentDepth, maxDepth);
      parent.right.points = null;//Clear points after subdivision
    }
  }

  get rootBox => _root.box;
}