library rapid.test.kd_tree_test;

import 'package:unittest/unittest.dart';
import 'package:rapid/rapid.dart';

void testBuild()
{}

void testBuildFromList()
{}

void testInsert()
{}

void testRemove()
{}

void testSearchNear() {}

void testSearchMultiNear() {}

void main()
{
  group('KdTree', () {
    test('Build', testBuild);
    test('Build from list', testBuildFromList);
    test('Insert', testInsert);
    test('Remove', testRemove);
    test('Search nearest', testSearchNear);
    test('Search multiple nearest', testSearchMultiNear);
  });
}