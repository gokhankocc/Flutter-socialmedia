import 'package:cloud_firestore/cloud_firestore.dart';

class Gonderi {
  final String? id;
  final String? gonderiResmiUrl;
  final String? aciklama;
  final String? yayinlayanId;
  final int? begeniSayisi;
  final String? konum;

  Gonderi({
    required this.id,
    this.gonderiResmiUrl = '',
    this.aciklama = '',
    this.yayinlayanId = '',
    this.begeniSayisi,
    this.konum = '',
  });

  factory Gonderi.dokumandanUret(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic>? data = doc.data()!;
    return Gonderi(
      id: doc.id,
      gonderiResmiUrl:
          data.containsKey("gonderiResmiUrl") ? data["gonderiResmiUrl"] : '',
      aciklama: data.containsKey("aciklama") ? data["fotoUrl"] : '',
      yayinlayanId:
          data.containsKey("yayinlayanId") ? data["yayinlayanId"] : '',
      begeniSayisi:
          data.containsKey("begeniSayisi") ? data["begeniSayisi"] : '',
      konum: data.containsKey("konum") ? data["konum"] : '',
    );
  }
}
