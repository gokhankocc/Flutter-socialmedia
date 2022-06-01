// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageServisi {
  Reference _storage = FirebaseStorage.instance.ref();
  String? resimId;

  Future<String?> gonderiResmiYukle(File resimDosyasi) async {
    resimId = Uuid().v4();
    //Uuid().v4() : bununla benzersiz resim linkleri üretiyoruz.
    UploadTask yuklemeYoneticisi = _storage
        .child("resimler/gonderiler/gonderi_$resimId.jpg")
        .putFile(resimDosyasi);
    //burada dosyayı gonderi.jpg içine kaydedip pıtfile ile içine koyarız.

    TaskSnapshot snapshot = await yuklemeYoneticisi;

    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    //getDownload ile yükenen dosyanin linkini isteriz.
    return yuklenenResimUrl;
  }

  /*Future<String> profilResmiYukle(File resimDosyasi) async {
    resimId = Uuid().v4();
    UploadTask yuklemeYoneticisi = _storage.child("resimler/profil/profil_$resimId.jpg").putFile(resimDosyasi);
    TaskSnapshot snapshot = await yuklemeYoneticisi;
    String yuklenenResimUrl = await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;
  }

  void gonderiResmiSil(String gonderiResmiUrl){
    RegExp arama = RegExp(r"gonderi_.+\.jpg");
    var eslesme = arama.firstMatch(gonderiResmiUrl);
    String dosyaAdi = eslesme[0];

    if(dosyaAdi != null){
      _storage.child("resimler/gonderiler/$dosyaAdi").delete();
    }
  }*/

}
