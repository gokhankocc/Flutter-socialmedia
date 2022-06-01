// ignore_for_file: prefer_typing_uninitialized_variables

//bu clasta kullanıcı üreten iki tane makine var
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Kullanici {
  final String? id;
  final String? kullaniciAdi;
  final String? fotoUrl;
  final String? eMail;
  final String? hakkinda;

  Kullanici({
    required this.id,
    this.kullaniciAdi = '',
    this.fotoUrl = '',
    this.eMail = '',
    this.hakkinda = '',
  });

  //factory : telefon santrali gibi davranır yani bir aracı gibi düşünüleilir.

  factory Kullanici.dokumandanUret(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic>? data = doc.data()!;
    return Kullanici(
      id: doc.id,
      kullaniciAdi:
          data.containsKey("kullaniciAdi") ? data["kullaniciAdi"] : '',
      fotoUrl: data.containsKey("fotoUrl") ? data["fotoUrl"] : '',
      eMail: data.containsKey("eMail") ? data["eMail"] : '',
      hakkinda: data.containsKey("hakkinda") ? data["hakkinda"] : '',
    );
  }

  factory Kullanici.firebasedenUret(User kullanici) {
    return Kullanici(
      id: kullanici.uid,
      kullaniciAdi: kullanici.displayName,
      fotoUrl: kullanici.photoURL,
      eMail: kullanici.email,
    );
  }
}
