import 'dart:html';
import 'package:three/three.dart';
import 'package:rapid/rapid.dart';
import 'package:vector_math/vector_math.dart';
import 'package:three/extras/controls/trackball_controls.dart';

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;
TrackballControls controls;

Mesh mesh;

void main() {
  initWebGL();

  //Use a teapot
  var loader = new OBJLoader();
  loader.load("./teapot.obj");
  loader.then((obj) {

    var points = new List<Vector3>();
    var tris = new List<int>();

    ObbCollider collider = new ObbCollider.fromTriangles(tris, points, split: 2);

    addObject3D(points, tris);
    addColliderElement(collider);

    animate(0);
  });
}

void initWebGL() {
  var container = new Element.tag('div');
  document.body.nodes.add(container);

  scene = new Scene();

  camera = new PerspectiveCamera(70.0, window.innerWidth / window.innerHeight, 1.0, 1000.0);
  camera.position.z = 50.0;

  scene.add(camera);

  controls = new TrackballControls(camera);

  renderer = new WebGLRenderer();
  renderer.setSize(window.innerWidth, window.innerHeight);
  container.nodes.add(renderer.domElement);
  window.onResize.listen(onWindowResize);
}

void onWindowResize(e) {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
  controls.handleResize();
}

void animate(num time) {
  window.requestAnimationFrame(animate);
  controls.update();
  renderer.render(scene, camera);
}

void addObject3D(points, tris) {
  var geometry = new Geometry();
  var material = new MeshBasicMaterial(color: 0xff0000,
  blending: NormalBlending,
  side: DoubleSide,
  shading: SmoothShading,
  polygonOffset: true,
  polygonOffsetFactor: 1,
  polygonOffsetUnits: 1,
  overdraw: false,
  wireframe: true,
  fog: false);

  mesh = new Mesh(geometry, material);

  mesh.geometry.vertices = new List<Vector3>();
  mesh.geometry.faces = new List<Face3>();

  mesh.geometry.vertices.addAll(points);

  for (var i = 0 ; i < tris.length ; i+= 3) {
    var face = new Face3();

    face.a = tris[i];
    face.b = tris[i + 1];
    face.c = tris[i + 2];

    mesh.geometry.faces.add(face);
  }


  mesh.geometry.buffersNeedUpdate = true;
  mesh.geometry.uvsNeedUpdate = true;
  mesh.geometry.verticesNeedUpdate = true;
  mesh.geometry.normalsNeedUpdate = true;
  mesh.geometry.colorsNeedUpdate = true;
  mesh.geometry.computeFaceNormals();
  mesh.geometry.computeCentroids();
  mesh.geometry.computeVertexNormals();

  scene.add(mesh);
}

addColliderElement(ObbCollider collider) {
  ObbTree rootTree = collider.tree;
  drawObbTreeNode(rootTree.root);
}

drawObbTreeNode(ObbTreeNode node) {
  if (node == null) {
    return;
  }

  var geometry = new CubeGeometry(node.box.halfExtents[0] * 2.0, node.box.halfExtents[1] * 2.0, node.box.halfExtents[2] * 2.0);
  var material = new MeshBasicMaterial(color: 0x00ff00,
  wireframe: true,
  blending: NormalBlending,
  side: DoubleSide,
  shading: FlatShading,
  polygonOffset: true,
  polygonOffsetFactor: 1,
  polygonOffsetUnits: 1,
  overdraw: true,
  fog: false);

  var obj = new Mesh(geometry, material);
  obj.position = node.box.center;
  obj.matrix.rotate(node.box.axis0, node.box.halfExtents[0]);
  obj.matrix.rotate(node.box.axis1, node.box.halfExtents[1]);
  obj.matrix.rotate(node.box.axis2, node.box.halfExtents[2]);
  obj.updateMatrix();
  scene.add(obj);


  drawObbTreeNode(node.left);
  drawObbTreeNode(node.right);
}