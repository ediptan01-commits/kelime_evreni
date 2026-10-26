import 'package:flutter_test/flutter_test.dart';
import 'package:kelime_evreni/game_data.dart';

void main() {
  test('Her dunyanin baslangici ve tum dallari gecerli', () {
    for (final world in worlds) {
      expect(world.nodes.containsKey(world.start), isTrue);
      expect(world.nodes.length, greaterThanOrEqualTo(3));
      for (final node in world.nodes.values) {
        expect(node.choices.any((choice) => choice.valid), isTrue);
        for (final choice in node.choices) {
          if (choice.nextId != null) {
            expect(world.nodes.containsKey(choice.nextId), isTrue);
          }
        }
      }
    }
  });

  test('Her dunya icin kazanan yol bulunabilir', () {
    bool canFinish(World world, String id, Set<String> visited) {
      if (visited.contains(id)) return false;
      final nextVisited = {...visited, id};
      return world.nodes[id]!.choices.where((c) => c.valid).any((c) =>
        c.nextId == null || canFinish(world, c.nextId!, nextVisited));
    }
    for (final w in worlds) {
      expect(canFinish(w, w.start, {}), isTrue, reason: w.title);
    }
  });
}
