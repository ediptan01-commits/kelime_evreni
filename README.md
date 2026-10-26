# Kelime Evreni — Flutter MVP v0.1.0

Kavramlar arasında neden-sonuç bağlantısı kurarak dünyaları onardığın Türkçe eğitici macera.

## Oyun kuralları

1. Bir dünya seç. Yeni dünya önceki dünyayı tamamlayınca açılır.
2. Her dünyada 3 anlam/mantık bağı oluştur.
3. Her adımda birden fazla kelime sunulur. Doğru seçim ilerletir; bazı bölümlerde iki farklı doğru yol vardır.
4. Yanlış cevap açıklama verir ve 1 enerji düşürür. 5 enerjiyle başlarsın.
5. İpucu 1 enerji harcar. Enerji bitince bölüm yeniden başlatılabilir.
6. Tamamlanan dünya için ilk bitirişte 1-3 yıldız ve XP kazanırsın; yeniden oynama ekstra puan üretmez.
7. Son ekranda kısa, doğrulanabilir bir öğrenme kartı çıkar.

## GitHub üzerinden telefona APK

1. Yeni, boş bir GitHub deposu aç; ZIP içindeki **klasörün içeriğini** depo köküne yükle (gizli `.github` klasörü dahil).
2. `Actions > Kelime Evreni Android APK > Run workflow` seç. Alternatif: main dalına push et.
3. İş akışı `flutter create` ile Android platform dosyalarını üretir, bağımlılıkları yükler, analiz/test yapar ve release APK derler.
4. Başarılı çalışmanın en altındaki `Artifacts > Kelime-Evreni-APK` dosyasını indir. ZIP içinden `app-release.apk` çıkar.
5. APK'yı Android telefona yükle. GitHub artifact ZIP olduğu için önce çıkarılması gerekir.

Yerel geliştirme (Flutter SDK kuruluysa):
```
flutter create --platforms=android --org com.teknolojix .
flutter pub get
flutter test
flutter run
```

## Kısıtlar

- Bu sürüm 6 dünya/18 mantık bağı içerir, kalıcı kayıt veya internet entegrasyonu içermez.
- 2D sahne temsili ikon/renk/animasyon geçişi şeklindedir; ayrıntılı çizimli dünya ve ses efektleri daha sonraki sürümde eklenecektir.
- APK, test amaçlı Flutter varsayılan debug olmayan imzayla üretilebilir; Play Store için kalıcı özel yükleme anahtarı ve AAB gerekir.
- Reklam, abonelik, yapay zekâ ve çok oyunculu özellikler MVP'de yer almaz.
