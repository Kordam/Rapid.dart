library rapid.test.everything;

import 'kd_tree_test.dart' as kdtree;
import 'world_test.dart' as world;
import 'body_test.dart'  as body;
import 'obb_tree_test.dart' as obb_tree;
import 'obb_collider_test.dart' as obb_collider;
import 'utils.dart' as utils;

void main()
{
  kdtree.main();
  body.main();
  world.main();
  obb_tree.main();
  obb_collider.main();
  utils.main();
}