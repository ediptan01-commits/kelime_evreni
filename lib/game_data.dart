import 'package:flutter/material.dart';

/// Her adim bir kavramsal baglantidir. nextId null ise dunya kurtarilir.
class Choice {
  final String word;
  final String explanation;
  final String? nextId;
  final bool valid;
  const Choice(this.word, this.explanation, this.nextId, {this.valid = true});
}

class PuzzleNode {
  final String id;
  final String prompt;
  final List<Choice> choices;
  const PuzzleNode(this.id, this.prompt, this.choices);
}

class World {
  final String title;
  final String subtitle;
  final String goal;
  final String fact;
  final IconData icon;
  final Color color;
  final String start;
  final Map<String, PuzzleNode> nodes;
  const World({required this.title, required this.subtitle, required this.goal,
    required this.fact, required this.icon, required this.color,
    required this.start, required this.nodes});
}

const worlds = <World>[
  World(
    title: 'Rüzgâr Köyü', subtitle: 'Doğanın Şifresi',
    goal: 'Karanlık köye yeniden enerji getir.',
    fact: 'Rüzgâr türbinleri hareket enerjisini jeneratör aracılığıyla elektrik enerjisine dönüştürür.',
    icon: Icons.air, color: Color(0xFF43D9D0), start: 'a', nodes: {
      'a': PuzzleNode('a', 'Elektrik üretmek için hangi doğal güçten yararlanabiliriz?', [
        Choice('RÜZGÂR', 'Rüzgâr türbinleri döndürebilir.', 'wind'),
        Choice('SU AKIŞI', 'Akan su da türbini döndürebilir.', 'water'),
        Choice('GÖLGE', 'Gölge kendi başına mekanik güç oluşturmaz.', 'a', valid: false),
      ]),
      'wind': PuzzleNode('wind', 'Rüzgârın hareketi hangi parçayı döndürür?', [
        Choice('TÜRBİN KANADI', 'Rüzgâr kanatlara kuvvet uygular.', 'generator'),
        Choice('TAŞ', 'Taş bu düzende hareketi jeneratöre iletmez.', 'wind', valid: false),
        Choice('DUMAN', 'Duman elektrik üretim mekanizması değildir.', 'wind', valid: false),
      ]),
      'water': PuzzleNode('water', 'Suyun hareketi hangi parçayı döndürür?', [
        Choice('SU TÜRBİNİ', 'Akan su türbin çarkını çevirebilir.', 'generator'),
        Choice('AMPUL', 'Ampul suyun hareketini doğrudan elektriğe çevirmez.', 'water', valid: false),
        Choice('BULUT', 'Bulut bu düzende mekanik dönme sağlamaz.', 'water', valid: false),
      ]),
      'generator': PuzzleNode('generator', 'Dönme hareketini hangi aygıt elektriğe dönüştürür?', [
        Choice('JENERATÖR', 'Jeneratör elektromanyetik indüksiyonla elektrik üretir.', null),
        Choice('TERMOMETRE', 'Termometre sıcaklık ölçer.', 'generator', valid: false),
        Choice('PUSULA', 'Pusula yön gösterir.', 'generator', valid: false),
      ]),
    },
  ),
  World(
    title: 'Solgun Bahçe', subtitle: 'Doğanın Şifresi',
    goal: 'Bahçedeki bitkilere yeniden yaşam ver.',
    fact: 'Fotosentez için ışık, su ve karbondioksit gereklidir; bitkiler bu süreçte besin üretir.',
    icon: Icons.local_florist, color: Color(0xFF8BEB95), start: 'a', nodes: {
      'a': PuzzleNode('a', 'Bitkinin köklerinden aldığı temel madde nedir?', [
        Choice('SU', 'Kökler topraktan su alır.', 'b'),
        Choice('CAM', 'Cam bitkinin köklerinden aldığı bir besin değildir.', 'a', valid: false),
        Choice('PLASTİK', 'Plastik bitkinin su ihtiyacını karşılamaz.', 'a', valid: false),
      ]),
      'b': PuzzleNode('b', 'Bitki, fotosentez için hangi enerji kaynağını kullanır?', [
        Choice('GÜNEŞ IŞIĞI', 'Işık, fotosenteze enerji sağlar.', 'c'),
        Choice('GÜRÜLTÜ', 'Ses fotosentezde enerji kaynağı değildir.', 'b', valid: false),
        Choice('GÖLGE', 'Gölge ışığı azaltır.', 'b', valid: false),
      ]),
      'c': PuzzleNode('c', 'Bitki havadan hangi gazı alarak fotosentez yapar?', [
        Choice('KARBONDİOKSİT', 'Fotosentezde karbondioksit kullanılır.', null),
        Choice('HELYUM', 'Helyum fotosentezin girdisi değildir.', 'c', valid: false),
        Choice('ARGON', 'Argon fotosentezin girdisi değildir.', 'c', valid: false),
      ]),
    },
  ),
  World(
    title: 'Kayıp Kütüphane', subtitle: 'Kayıp Harfler',
    goal: 'Anlamı kaybolan eski kitabı yeniden aç.',
    fact: 'Eş anlamlı sözcükler yakın veya aynı anlamı taşır; bağlama göre kullanımları değişebilir.',
    icon: Icons.auto_stories, color: Color(0xFFF3B66A), start: 'a', nodes: {
      'a': PuzzleNode('a', '“Yanıt” kelimesinin eş anlamlısını bul.', [
        Choice('CEVAP', 'Yanıt ve cevap eş anlamlıdır.', 'b'),
        Choice('SORU', 'Soru, yanıtın eş anlamlısı değildir.', 'a', valid: false),
        Choice('SEBEP', 'Sebep, neden anlamına gelir.', 'a', valid: false),
      ]),
      'b': PuzzleNode('b', '“Özgür” kelimesinin eş anlamlısını bul.', [
        Choice('HÜR', 'Özgür ve hür eş anlamlıdır.', 'c'),
        Choice('ESİR', 'Esir zıt anlamlıdır.', 'b', valid: false),
        Choice('KIRGIN', 'Kırgın farklı bir duyguyu anlatır.', 'b', valid: false),
      ]),
      'c': PuzzleNode('c', '“Konuk” kelimesinin eş anlamlısını bul.', [
        Choice('MİSAFİR', 'Konuk ve misafir eş anlamlıdır.', null),
        Choice('KOMŞU', 'Komşu ile konuk aynı anlama gelmez.', 'c', valid: false),
        Choice('YOLCU', 'Yolcu seyahat eden kişidir.', 'c', valid: false),
      ]),
    },
  ),
  World(
    title: 'Zaman Kapısı', subtitle: 'Tarih ve Keşif',
    goal: 'Tarih makinesinin bilgi kilidini çöz.',
    fact: 'Yazının ilk örnekleri Mezopotamya’da ortaya çıktı; çivi yazısı kil tabletler üzerinde kullanıldı.',
    icon: Icons.hourglass_bottom, color: Color(0xFFCE9BFF), start: 'a', nodes: {
      'a': PuzzleNode('a', 'Çivi yazısıyla bilinen eski uygarlık hangisidir?', [
        Choice('SÜMERLER', 'Sümerler çivi yazısını kullandı.', 'b'),
        Choice('VİKİNGLER', 'Vikingler çok daha sonraki bir dönemde yaşadı.', 'a', valid: false),
        Choice('ROMALILAR', 'Romalılar esas olarak Latin alfabesi kullandı.', 'a', valid: false),
      ]),
      'b': PuzzleNode('b', 'Çivi yazısı genellikle neyin üzerine yazılırdı?', [
        Choice('KİL TABLET', 'Islak kil üzerine işaretler basılırdı.', 'c'),
        Choice('EKRAN', 'O dönemde elektronik ekran yoktu.', 'b', valid: false),
        Choice('PLASTİK', 'Plastik modern bir malzemedir.', 'b', valid: false),
      ]),
      'c': PuzzleNode('c', 'Yazı sayesinde hangi bilgi korunabildi?', [
        Choice('KAYITLAR', 'Yazı, bilgiyi nesiller arasında aktardı.', null),
        Choice('RÜZGÂR', 'Rüzgâr yazıyla saklanamaz.', 'c', valid: false),
        Choice('GÖLGE', 'Gölge yazıyla saklanamaz.', 'c', valid: false),
      ]),
    },
  ),
  World(
    title: 'Mantık Köprüsü', subtitle: 'Zekâ Şehri',
    goal: 'Karşıya geçmek için sebep-sonuç zincirini tamamla.',
    fact: 'Bilimsel düşünme, gözlem ve neden-sonuç ilişkilerini kanıtlarla değerlendirmeyi gerektirir.',
    icon: Icons.hub, color: Color(0xFF7FC9FF), start: 'a', nodes: {
      'a': PuzzleNode('a', 'Yağmur yağdı. Toprak neden ıslandı?', [
        Choice('SU TEMASI', 'Yağmur damlaları toprağa temas etti.', 'b'),
        Choice('SES', 'Yağmurun sesi toprağı ıslatmaz.', 'a', valid: false),
        Choice('RENK', 'Renk değişimi ıslanmanın nedeni değildir.', 'a', valid: false),
      ]),
      'b': PuzzleNode('b', 'Güneş açtı. Islak toprağın suyu ne olur?', [
        Choice('BUHARLAŞIR', 'Su, uygun koşullarda gaz hâline geçer.', 'c'),
        Choice('TAŞLAŞIR', 'Su doğrudan taşa dönüşmez.', 'b', valid: false),
        Choice('ÇOĞALIR', 'Güneş suyu kendi başına çoğaltmaz.', 'b', valid: false),
      ]),
      'c': PuzzleNode('c', 'Su buharı soğuyunca hangi olay olabilir?', [
        Choice('YOĞUŞMA', 'Su buharı sıvı damlacıklarına dönüşebilir.', null),
        Choice('YANMA', 'Yoğuşma yanma değildir.', 'c', valid: false),
        Choice('MIKNATISLANMA', 'Bununla ilgisi yoktur.', 'c', valid: false),
      ]),
    },
  ),
  World(
    title: 'Ses Ormanı', subtitle: 'Kayıp Harfler',
    goal: 'Sesleri doğru kelimelere bağlayarak ormanı uyandır.',
    fact: 'Yansıma sözcükler, doğadaki sesleri taklit ederek oluşur: şırıl şırıl, vızıldamak, tıkırtı.',
    icon: Icons.forest, color: Color(0xFFB8E986), start: 'a', nodes: {
      'a': PuzzleNode('a', 'Arının sesini anlatan sözcük hangisi?', [
        Choice('VIZILTI', 'Arıların çıkardığı ses vızıltıdır.', 'b'),
        Choice('ŞIRILTI', 'Şırıltı genellikle suyu anlatır.', 'a', valid: false),
        Choice('ÇATIRTI', 'Çatırtı kırılma veya çatlama sesidir.', 'a', valid: false),
      ]),
      'b': PuzzleNode('b', 'Akan derenin sesini anlatan sözcük?', [
        Choice('ŞIRILTI', 'Suyun akış sesi şırıltıdır.', 'c'),
        Choice('VIZILTI', 'Vızıltı farklı bir sestir.', 'b', valid: false),
        Choice('TIKIRTI', 'Tıkırtı küçük vurma sesidir.', 'b', valid: false),
      ]),
      'c': PuzzleNode('c', 'Saatin ritmik sesine uygun kelime hangisi?', [
        Choice('TİK TAK', 'Saat sesinin yansımasıdır.', null),
        Choice('GÜRÜLTÜ', 'Çok genel bir sestir.', 'c', valid: false),
        Choice('FISILTI', 'Fısıltı alçak sesle konuşmadır.', 'c', valid: false),
      ]),
    },
  ),
];
