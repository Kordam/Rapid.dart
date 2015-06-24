import 'dart:html';
import 'package:three/three.dart';
import 'package:rapid/rapid.dart';
import 'package:vector_math/vector_math.dart';
import 'package:three/extras/controls/trackball_controls.dart';

PerspectiveCamera camera;
Scene scene;
WebGLRenderer renderer;
TrackballControls controls;
World world = new World.empty();

void main() {
  initWebGL();

  //Use a teapot
  var loader = new OBJLoader(useMtl: false);// new JSONLoader();
  loader.load("./teapot.obj").then((Object3D obj) {
    //Getting points & tris from obj
    var points = new List<Vector3>();
    var tris = new List<int>();
    
    if (obj.geometry != null) {
      points.addAll(obj.geometry.vertices);
      obj.geometry.faces.forEach((Face f) {
        tris.addAll(f.indices);
        print(f.indices);
      });
    }
    if (obj.children != null) {
      obj.children.forEach((Object3D o3d) {
        if (o3d.geometry != null) {
          points.addAll(o3d.geometry.vertices);
          o3d.geometry.faces.forEach((Face f) {
            tris.addAll(f.indices);
          });
        }
      });
    }

    ObbCollider collider = new ObbCollider.fromTriangles(tris, points, split: 5);
    Mesh m = createMesh(points, tris);
    scene.add(m);

    animate(0);
  });
}

void initWebGL() {
  var container = new Element.tag('div');
  document.body.nodes.add(container);

  scene = new Scene();

  camera = new PerspectiveCamera(70.0, window.innerWidth / window.innerHeight, 1.0, 1000.0);
  camera.position.z = 25.0;

  scene.add(camera);

  controls = new TrackballControls(camera);

  renderer = new WebGLRenderer();
  renderer.setClearColorHex(0x000000, 1);
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

Mesh createMesh(points, tris) {
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

  Mesh mesh = new Mesh(geometry, material);

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

  return mesh;
}