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

  var points = new List<Vector3>();
  points.add(new Vector3(0.0, 0.0, 0.0)); // Top face bl
  points.add(new Vector3(10.0, 0.0, 0.0)); // Top face br
  points.add(new Vector3(10.0, 10.0, 0.0)); // Top face tr
  points.add(new Vector3(0.0, 10.0, 0.0)); // Top face tl
  points.add(new Vector3(0.0, 0.0, 10.0)); //Left face bl
  points.add(new Vector3(0.0, 10.0, 10.0)); //Left face tl
  points.add(new Vector3(10.0, 0.0, 10.0)); //Right face bl
  points.add(new Vector3(10.0, 10.0, 10.0)); //Right face tl

  var tris = new List<int>();
  tris.add(0); tris.add(1); tris.add(2); //Tri front face 1
  tris.add(0); tris.add(2); tris.add(3); //Tri front face 2
  tris.add(2); tris.add(3); tris.add(5); //Tri top face 1
  tris.add(2); tris.add(5); tris.add(7); //Tri top face 2
  tris.add(0); tris.add(1); tris.add(4); //Tri bottom face 1
  tris.add(1); tris.add(4); tris.add(6); //Tri bottom face 2
  tris.add(0); tris.add(3); tris.add(4); //Tri left face 1
  tris.add(3); tris.add(4); tris.add(5); //Tri left face 2
  tris.add(1); tris.add(2); tris.add(6); //Tri right face 1
  tris.add(2); tris.add(6); tris.add(7); //Tri right face 2

  ObbCollider collider = new ObbCollider.fromTriangles(tris, points, split: 0);

  addObject3D(points, tris);
  addColliderElement(collider);

  animate(0);
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
  mesh.geometry.computeBoundingSphere();
  mesh.geometry.computeBoundingBox();
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

  var geometry = new CubeGeometry(1.0, 1.0, 1.0);
  var material = new MeshBasicMaterial(color: 0x00ff00,
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
  scene.add(obj);


  drawObbTreeNode(node.left);
  drawObbTreeNode(node.right);
}