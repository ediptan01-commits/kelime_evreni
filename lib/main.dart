import 'package:flutter/material.dart';
import 'game_data.dart';

void main() => runApp(const KelimeEvreni());

const bg = Color(0xFF0C1027);
const panel = Color(0xFF1B2343);
const soft = Color(0xFFB7C6E8);

class KelimeEvreni extends StatelessWidget {
  const KelimeEvreni({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Kelime Evreni',
    theme: ThemeData(useMaterial3: true, brightness: Brightness.dark,
      scaffoldBackgroundColor: bg, colorSchemeSeed: const Color(0xFF66D9FF),
      textTheme: const TextTheme(titleLarge: TextStyle(fontWeight: FontWeight.w800),
        headlineSmall: TextStyle(fontWeight: FontWeight.w900))),
    home: const AdventurePage(),
  );
}

class AdventurePage extends StatefulWidget {
  const AdventurePage({super.key});
  @override
  State<AdventurePage> createState() => _AdventurePageState();
}

class _AdventurePageState extends State<AdventurePage> {
  int? activeWorld;
  int unlocked = 0;
  int totalStars = 0;
  int xp = 0;
  int energy = 5;
  int mistakes = 0;
  int steps = 0;
  String nodeId = '';
  String? feedback;
  bool completed = false;
  final Set<int> completedWorlds = {};
  final List<String> trail = [];

  void startWorld(int index) => setState(() {
    activeWorld = index;
    nodeId = worlds[index].start;
    energy = 5;
    mistakes = 0;
    steps = 0;
    feedback = null;
    completed = false;
    trail.clear();
  });

  void selectChoice(Choice choice) {
    if (completed || activeWorld == null || energy == 0) return;
    setState(() {
      feedback = choice.explanation;
      if (!choice.valid) {
        mistakes++;
        energy--;
        return;
      }
      trail.add(choice.word);
      steps++;
      if (choice.nextId == null) {
        completed = true;
        if (completedWorlds.add(activeWorld!)) {
          totalStars += mistakes == 0 ? 3 : mistakes <= 2 ? 2 : 1;
          xp += 100 + (energy * 10);
          if (activeWorld == unlocked && unlocked < worlds.length - 1) unlocked++;
        }
      } else {
        nodeId = choice.nextId!;
      }
    });
  }

  void showHint() {
    if (activeWorld == null || completed || energy <= 1) return;
    final correct = worlds[activeWorld!].nodes[nodeId]!.choices.where((x) => x.valid).first;
    setState(() {
      energy--;
      feedback = 'İPUCU: ${correct.word.substring(0, 1)} harfiyle başlayan kavramı düşün. Bir enerji harcandı.';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 12), child: Row(children: [
        if (activeWorld != null) IconButton(onPressed: () => setState(() => activeWorld = null),
          icon: const Icon(Icons.arrow_back_ios_new))
        else const Icon(Icons.auto_awesome, color: Color(0xFF85E6FF), size: 32),
        const SizedBox(width: 8),
        const Expanded(child: Text('KELİME EVRENİ', style: TextStyle(fontSize: 21, letterSpacing: 1.3, fontWeight: FontWeight.w900))),
        const Icon(Icons.star_rounded, color: Color(0xFFFFD066)),
        Text(' $totalStars', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ])),
      Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 250),
        child: activeWorld == null ? _mapPage() : _gamePage(worlds[activeWorld!])))
    ])),
  );

  Widget _mapPage() => ListView(key: const ValueKey('map'), padding: const EdgeInsets.all(20), children: [
    _glowCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('🌌  KAYIP KELİMELERİ GERİ GETİR', style: TextStyle(color: Color(0xFF9EDFF5), fontSize: 12, letterSpacing: 1.3, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      const Text('Her doğru bağ,\nbir dünyayı değiştirir.', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, height: 1.15)),
      const SizedBox(height: 15),
      Text('Öğren • Keşfet • Onar     |     $xp XP', style: const TextStyle(color: soft)),
      const SizedBox(height: 14),
      LinearProgressIndicator(value: completedWorlds.length / worlds.length,
        minHeight: 7, borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.white12, color: const Color(0xFF70E4D3)),
      const SizedBox(height: 8),
      Text('${completedWorlds.length}/${worlds.length} dünya onarıldı', style: const TextStyle(color: soft)),
    ])),
    const SizedBox(height: 26),
    const Text('EVREN HARİTASI', style: TextStyle(fontSize: 15, letterSpacing: 2, color: soft, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    for (int i = 0; i < worlds.length; i++) Padding(padding: const EdgeInsets.only(bottom: 12),
      child: _worldTile(i)),
    const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text(
      'İlk sürüm: 6 dünya, her dünyada 3 mantık bağı. İlerleme uygulama açıkken korunur; kalıcı kayıt sonraki sürümde eklenecek.',
      textAlign: TextAlign.center, style: TextStyle(color: soft, fontSize: 12))),
  ]);

  Widget _worldTile(int i) {
    final w = worlds[i];
    final locked = i > unlocked;
    final done = completedWorlds.contains(i);
    return Opacity(opacity: locked ? 0.48 : 1,
      child: Material(color: panel, borderRadius: BorderRadius.circular(20),
        child: InkWell(borderRadius: BorderRadius.circular(20),
          onTap: locked ? null : () => startWorld(i),
          child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Container(width: 60, height: 60, decoration: BoxDecoration(color: w.color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(17)), child: Icon(w.icon, color: w.color, size: 31)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${i + 1}. ${w.title}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5), Text(w.subtitle, style: const TextStyle(color: soft, fontSize: 12)),
              if (done) const Padding(padding: EdgeInsets.only(top: 4), child: Text('✓ Onarıldı', style: TextStyle(color: Color(0xFF89E8AA), fontSize: 12))),
            ])),
            Icon(locked ? Icons.lock : done ? Icons.check_circle : Icons.play_circle_fill, color: w.color),
          ])))));
  }

  Widget _gamePage(World w) {
    final node = w.nodes[nodeId]!;
    return ListView(key: ValueKey('world$activeWorld'), padding: const EdgeInsets.fromLTRB(20, 12, 20, 24), children: [
      Row(children: [Icon(w.icon, color: w.color), const SizedBox(width: 9),
        Expanded(child: Text(w.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900))),
        const Icon(Icons.bolt, color: Colors.amber), Text('$energy/5', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
      const SizedBox(height: 7), Text(w.goal, style: const TextStyle(color: soft)),
      const SizedBox(height: 18),
      _scene(w),
      const SizedBox(height: 14),
      if (trail.isNotEmpty) Wrap(spacing: 7, runSpacing: 7, children: [
        for (final word in trail) Chip(label: Text(word, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          backgroundColor: w.color.withValues(alpha: 0.13), side: BorderSide(color: w.color.withValues(alpha: 0.25))),
      ]),
      const SizedBox(height: 18),
      if (completed) _finishCard(w)
      else if (energy == 0) _failedCard()
      else ...[
        Text('BAĞ ${steps + 1}/3', style: TextStyle(color: w.color, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(node.prompt, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        for (final c in node.choices) Padding(padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(onPressed: () => selectChoice(c),
            style: ElevatedButton.styleFrom(backgroundColor: panel, foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(58), alignment: Alignment.centerLeft,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            child: Row(children: [Expanded(child: Text(c.word, style: const TextStyle(fontWeight: FontWeight.bold))), const Icon(Icons.chevron_right)]))),
        Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: energy <= 1 ? null : showHint,
          icon: const Icon(Icons.lightbulb_outline), label: const Text('İpucu (−1 enerji)'))),
      ],
      if (feedback != null) Padding(padding: const EdgeInsets.only(top: 10), child:
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFF22345A),
          borderRadius: BorderRadius.circular(14)), child: Text(feedback!, style: const TextStyle(fontSize: 14)))),
    ]);
  }

  Widget _scene(World w) => Container(height: 174, decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(23),
    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
      colors: [w.color.withValues(alpha: .32), const Color(0xFF20264E), const Color(0xFF11152E)])),
    child: Stack(alignment: Alignment.center, children: [
      Positioned(top: 16, right: 22, child: Icon(Icons.auto_awesome, color: w.color.withValues(alpha: .65), size: 34)),
      Icon(completed ? Icons.auto_awesome : w.icon, color: w.color, size: 92),
      Positioned(bottom: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(30)),
        child: Text(completed ? '✨ DÜNYA ONARILDI' : '✨ ${steps * 33}% CANLANDI',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)))),
    ]));

  Widget _finishCard(World w) => _glowCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('🎉 GÖREV TAMAMLANDI!', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
    const SizedBox(height: 12),
    Text('Bu dünya yeniden canlandı. ${mistakes == 0 ? 'Kusursuz çözüm: 3 yıldız!' : 'Güzel bir keşif!'}'),
    const SizedBox(height: 18),
    const Text('📖 BİLGİ HAZİNESİ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF89EAD7))),
    const SizedBox(height: 7), Text(w.fact, style: const TextStyle(height: 1.5)),
    const SizedBox(height: 22),
    FilledButton(onPressed: () { if (activeWorld! < worlds.length - 1) startWorld(activeWorld! + 1); else setState(() => activeWorld = null); },
      child: Text(activeWorld! < worlds.length - 1 ? 'SONRAKİ DÜNYA →' : 'HARİTAYA DÖN')),
    TextButton(onPressed: () => setState(() => activeWorld = null), child: const Text('Haritaya dön')),
  ]));

  Widget _failedCard() => _glowCard(Column(children: [
    const Text('⚡ ENERJİ BİTTİ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
    const SizedBox(height: 9),
    const Text('Hatalar öğrenmenin bir parçası. Aynı dünyayı yeniden dene.'),
    const SizedBox(height: 18),
    FilledButton(onPressed: () => startWorld(activeWorld!), child: const Text('TEKRAR DENE')),
  ]));

  Widget _glowCard(Widget child) => Container(width: double.infinity, padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24),
      gradient: const LinearGradient(colors: [Color(0xFF282753), Color(0xFF18284A)]),
      border: Border.all(color: Colors.white12)), child: child);
}
