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
    Obb3 box = Obb3_fitFromPoints(points);
    _root = new ObbTreeNode(1, box, points: points);
    if (divide > 1) {
      _split(_root, 1, divide);
      _root.points.clear(); //Clear points after subdivision
      _root.points = null;
    }
  }

  //Recursive method that splits the [parent] node
  //by filling the left an right child nodes
  void _split(ObbTreeNode parent, int currentDepth, int maxDepth)
  {
    currentDepth++;
    if (currentDepth == maxDepth) {
      parent.left.leaf = true;
      parent.right.leaf = true;
      return;
    }
    else {
      _split(parent.left, currentDepth, maxDepth);
      parent.left.points.clear(); //Clear points after subdivision
      parent.left.points = null;
      _split(parent.right, currentDepth, maxDepth);
      parent.right.points.clear(); //Clear points after subdivision
      parent.right.points = null;
    }
  }

  get rootBox => _root.box;
}