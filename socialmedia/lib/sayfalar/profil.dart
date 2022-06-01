// ignore_for_file: prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_final_fields, unused_field, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/modeller/kullanici.dart';
import 'package:socialmedia/servisler/firestoreServisi.dart';
import 'package:socialmedia/servisler/yetkilendirmeServisi.dart';

class Profil extends StatefulWidget {
  final String? profilSahibiId;
  const Profil({Key? key, this.profilSahibiId}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  int _gonderisayisi = 0;
  int _takipci = 0;
  int _takipedilen = 0;

  _takipedilenSayisiGetir() async {
    int? takipedilenSayisi =
        await firestoreServisi().takipEdilenler(widget.profilSahibiId);
    print("takip edilen");
    print(takipedilenSayisi);
    print(widget.profilSahibiId);
    setState(() {
      _takipci = takipedilenSayisi;
    });
  }

  _takipciSayisiGetir() async {
    int? takipciSayisi =
        await firestoreServisi().takipciSayisi(widget.profilSahibiId);
    print("takpii");
    print(takipciSayisi);
    print(widget.profilSahibiId);
    setState(() {
      _takipci = takipciSayisi;
    });
  }

  @override
  void initState() {
    _takipciSayisiGetir();
    _takipedilenSayisiGetir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.grey[100],
        actions: <Widget>[
          IconButton(
              onPressed: _cikisYap,
              icon: Icon(Icons.exit_to_app, color: Colors.black))
        ],
      ),
      body: FutureBuilder<Object?>(
          future: firestoreServisi()
              .kullaniciGetir(widget.profilSahibiId), //profil verisi çekme
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: <Widget>[
                _profilDetaylari(snapshot.data),
              ],
            );
          }),
    );
  }

  Widget _profilDetaylari(Kullanici profilData) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (profilData.fotoUrl != null)
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50.0,
                  //backgroundImage: AssetImage("assets/images/hayalet.png"),
                  //backgroundImage: NetworkImage(profilData.fotoUrl.toString()),
                  backgroundImage: NetworkImage(profilData.fotoUrl.toString()),
                )
              else
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 50.0,
                  //backgroundImage: AssetImage("assets/images/hayalet.png"),
                  //backgroundImage: NetworkImage(profilData.fotoUrl.toString()),
                  backgroundImage: AssetImage("assets/images/hayalet.png"),
                ),
              Expanded(
                //row içinde row kullandıgımız için yatayda hizalama yapmadı sadece ihtiyacı olan yeri kullandı hizalama yapması için expended widgetini kullandık
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _sosyalSayac(baslik: "Gönderiler", sayi: _gonderisayisi),
                    //......................................................................................................
                    FutureBuilder<Object?>(
                        future: firestoreServisi().takipciSayisi(
                            widget.profilSahibiId), //profil verisi çekme
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return _sosyalSayac(
                              baslik: "Takipçi", sayi: snapshot.data);
                        }),
                    //...................................
                    FutureBuilder<Object?>(
                        future: firestoreServisi().takipEdilenler(
                            widget.profilSahibiId), //profil verisi çekme
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return _sosyalSayac(
                              baslik: "Takip", sayi: snapshot.data);
                        }),
                    //_sosyalSayac(baslik: "Takip", sayi: _takipedilen),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(profilData.kullaniciAdi.toString(),
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 5,
          ),
          Text(
            profilData.hakkinda.toString(),
          ),
          SizedBox(
            height: 25,
          ),
          _profiliDuzenleButon(),
        ],
      ),
    );
  }

  Widget _profiliDuzenleButon() {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        child: Text("Profili Düzenle"),
      ),
    );
  }

  Widget _sosyalSayac({String? baslik, int? sayi}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, //dikeyde hizala
      crossAxisAlignment: CrossAxisAlignment.center, //yatayda hizala
      children: <Widget>[
        Text(
          sayi.toString(),
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          baslik!,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }

  void _cikisYap() {
    Provider.of<yetkilendirmeServisi>(context, listen: false).cikisYap();
  }
}
