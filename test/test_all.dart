library rapid.test.everything;

import 'kd_tree_test.dart' as kdtree;
import 'world_test.dart' as world;
import 'obb_tree_test.dart' as obb_tree;

void main()
{
  kdtree.main();
  world.main();
  obb_tree.main();
}