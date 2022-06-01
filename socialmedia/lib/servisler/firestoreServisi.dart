// ignore_for_file: camel_case_types, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';

import '../modeller/kullanici.dart';

class firestoreServisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime zaman = DateTime.now();

  Future<void> kullaniciOlustur({id, email, kullaniciAdi, fotoUrl = ""}) async {
    await _firestore.collection("Kullanicilar").doc(id).set({
      "kullaniciAdi": kullaniciAdi,
      "email": email,
      "fotoUrl": fotoUrl,
      "hakkinda": "",
      "olusturulmaZamani": zaman
    });
  }

  Future<Kullanici?> kullaniciGetir(id) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection("Kullanicilar").doc(id).get();
    if (doc.exists) {
      //doc.exists : eğer böyle bir dokuman varsa demiş olduk
      Kullanici kullanici = Kullanici.dokumandanUret(doc);
      print(doc.get("takipciler"));
      return kullanici;
    }
    return null;
  }

  Future<int> takipciSayisi(kullaniciId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("Takipciler").doc(kullaniciId).get();
    print(snapshot.get("kullanicininTakipcileri"));

    return snapshot.get("kullanicininTakipcileri").length;
  }

  Future<int> takipEdilenler(kullaniciId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection("takipedilenler")
        .doc(kullaniciId)
        .collection("kullanicinintakipleri")
        .get();

    return snapshot.docs.length;
  }

  Future<void> gonderiOlustur(
      {gonderiResmiUrl, aciklama, yayinlayanId, konum}) async {
    await _firestore
        .collection("gonderiler")
        .doc(yayinlayanId)
        .collection("kullaniciGonderileri")
        .add({
      "gonderiResmiUrl": gonderiResmiUrl,
      "aciklama": aciklama,
      "yayinlayanId": yayinlayanId,
      "begeniSayisi": 0,
      "konum": konum,
      "olusturulmaZamani": zaman
    });
  }
}
