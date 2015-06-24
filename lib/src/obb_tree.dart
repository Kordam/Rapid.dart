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

  bool getTriangleCollision(ObbTreeNode oth, List<int> idx, List<Vector3> vertices) {
    bool res = false;
    if (box.intersectsWithObb3(oth.box) == false) {
      return false;
    }
    for (int i = 0; i < tris.length; i += 3) {
      Triangle t1 = new Triangle.points(points[tris[i]], points[tris[i + 1]], points[tris[i + 2]]);
      for (int j = 0; j < oth.tris.length; j += 3) {
        Triangle t2 = new Triangle.points(oth.points[oth.tris[j]], oth.points[oth.tris[j + 1]], oth.points[oth.tris[j + 2]]);
        if (Triangle_intersectsWithTriangle(t1, t2)) {
          idx.add(i); vertices.add(t1.point0);
          idx.add(i + 1); vertices.add(t1.point1);
          idx.add(i + 2); vertices.add(t1.point2);
          res = true;
        }
      }
    }
    return res;
  }
}

//Define an oriented bounding box tree data structure
class ObbTree
{
  ObbTreeNode       _root;
  List<ObbTreeNode> _leaf;

  //Construct on ObbTree from a list of [tris] indexes in [points] list
  //If no [tris], this is an empty 1.0/1.0/1.0 box at 0.0/0.0/0.0
  ObbTree.fromTriangles(List<int> tris, List<Vector3> points, int divide) {
    Vector m = new Vector3.zero();
    _leaf = new List();

    //Empty tris
    if (tris.length == 0) {
      var box = new Obb3();
      box.halfExtents.x = 0.0;
      box.halfExtents.y = 0.0;
      box.halfExtents.z = 0.0;
      _root = new ObbTreeNode(box, null, null, m, depth: 0, leaf: true);
      _leaf.add(_root);
      return;
    }
    Obb3 box = Obb3_fitFromTriangles(tris, points, mean: m);

    _root = new ObbTreeNode(box, points, tris, m, depth: 0, leaf: true);
    print("root node has ${tris.length} tris");
    if (divide >= 1) {
      _splitTriangles(_root, 1, divide);
      _root.leaf = false;
      _root.points = null;  //Clear points after subdivision
      _root.tris = null;  //Clear tris after subdivision
    }
    else {
      _root.leaf = true;
      _leaf.add(_root);
    }
  }

  //Update translation cache
  void translate(Vector3 vec) {
    _translate(vec, _root);
  }

  //Recursive translation update caching
  void _translate(Vector3 vec, ObbTreeNode node) {
    if (node == null) {
      return;
    }
    node.box.translate(vec);
    _translate(vec, node.left);
    _translate(vec, node.right);
  }

  //Update rotation caching
  //from euler [angles] in degree
  void rotate(Vector3 angles) {
    Matrix3 mat = new Matrix3.zero();
    mat.setRotationX(TO_RADIAN(angles[0]));
    mat.setRotationY(TO_RADIAN(angles[1]));
    mat.setRotationZ(TO_RADIAN(angles[2]));
    _rotate(mat, _root);
  }

  //Recursive rotation update caching
  void _rotate(Matrix3 mat, ObbTreeNode node) {
    if (node == null) {
      return;
    }
    node.box.rotate(mat);
    _rotate(mat, node.left);
    _rotate(mat, node.right);
  }

  //Recursive method that splits the [parent] node
  //on the longest axis of [node]
  //by filling the left an right child nodes
  void _splitTriangles(ObbTreeNode parent, int currentDepth, int maxDepth)
  {
    print("parent node has ${parent.tris.length} tris");
    var p = Obb3_splitPlane(parent.box, parent.box.center);
    print("Triangles split Depth ${currentDepth} center ${parent.box.center.toString()} Plane ${p.normal}[${p.constant}]}");

    //Sort tris and points
    List<int> left_tris = new List<int>();
    List<int> right_tris = new List<int>();
    List<Vector3> left_points = new List<Vector3>();
    List<Vector3> right_points  = new List<Vector3>();
    Plane_separateTris(p, parent.points, parent.tris, left_points, right_points, left_tris, right_tris);

    //Allocate Left part
    ObbTreeNode left = null;
    if (left_points.length > 0) {
      print("Depth ${currentDepth} has ${left_points.length} left points");
      Vector3 left_mean = new Vector3.zero();
      Obb3 left_box = Obb3_fitFromTriangles(left_tris, left_points, mean: left_mean);
      left = new ObbTreeNode(left_box, left_points, left_tris, left_mean, depth: currentDepth);
    }

    //Allocate right part
    ObbTreeNode right = null;
    if (right_points.length > 0) {
      print("Depth ${currentDepth} has ${right_points.length} right points");
      Vector3 right_mean = new Vector3.zero();
      Obb3 right_box = Obb3_fitFromTriangles(right_tris, right_points, mean: right_mean);
      right = new ObbTreeNode(right_box, right_points, right_tris, right_mean, depth: currentDepth);
    }

    //Assign parent node left & right
    parent.left = left;
    parent.right = right;
    if (left == null && right == null) {
      parent.leaf = true;
      _leaf.add(parent);
      return;
    }

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
      }
      if (right != null) {
        _splitTriangles(parent.right, currentDepth, maxDepth);
      }
    }
  }

  get root => _root;
  get rootBox => _root.box;
  get leaves => _leaf;
}