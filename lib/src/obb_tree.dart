part of rapid;

//Define a node within a binary data tree
class ObbTreeNode
{
  int   depth;
  Obb3  box;
  bool  leaf;
  ObbTreeNode left;
  ObbTreeNode right;
  List<Vector3> points;

  ObbTreeNode(this.depth, this.box,
              {this.leaf: false, this.left: null,
              this.right: null, this.points: null});
}

//Define an oriented bounding box tree data structure
class ObbTree
{
  ObbTreeNode _root;

  //Construct an ObbTree
  ObbTree.fromPoints(List<Vector3> points, int divide)
  {
    Vector m = new Vector3.zero();
    Obb3 box = Obb3_fitFromPoints(points, mean: m);
    //Allocate Left part
    Vector3 left_mean = new Vector3.zero();
    _root = new ObbTreeNode(1, box, points: points, leaf: true);
    if (divide >= 1) {
      _split(_root, m, 1, divide);
      _root.leaf = false;
      _root.points.clear(); //Clear points after subdivision
      _root.points = null;
    }
  }

  //Recursive method that splits the [parent] node
  //on the longest axis of [node] and the point [mean]
  //by filling the left an right child nodes
  void _split(ObbTreeNode parent, Vector3 mean, int currentDepth, int maxDepth)
  {

    //NOT THAT SIMPLE
    var p = Plane_fromAxisAndPoint(Obb3_longestAxis(parent.box), mean);

    //Sort points
    List<Vector3> left_points = new List<Vector3>();
    List<Vector3> right_points  = new List<Vector3>();

    //Allocate Left part
    Vector3 left_mean = new Vector3.zero();
    Obb3 left_box = Obb3_fitFromPoints(left_points, mean: left_mean);
    ObbTreeNode left = new ObbTreeNode(currentDepth, left_box, points: left_points);

    //Allocate right part
    Vector3 right_mean = new Vector3.zero();
    Obb3 right_box = Obb3_fitFromPoints(right_points, mean: right_mean);
    ObbTreeNode right = new ObbTreeNode(currentDepth, right_box, points: right_points);


    //Assign parent node left & right
    parent.left = left;
    parent.right = right;

    currentDepth++;
    if (currentDepth >= maxDepth) {
      parent.left.leaf = true;
      parent.right.leaf = true;
      return;
    }
    else {
      _split(parent.left, left_mean, currentDepth, maxDepth);
      parent.left.points.clear(); //Clear points after subdivision
      parent.left.points = null;
      _split(parent.right, right_mean, currentDepth, maxDepth);
      parent.right.points.clear(); //Clear points after subdivision
      parent.right.points = null;
    }
  }

  get rootBox => _root.box;
}