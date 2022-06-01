// ignore_for_file: prefer_const_constructors, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/modeller/kullanici.dart';
import 'package:socialmedia/sayfalar/anaSayfa.dart';
import 'package:socialmedia/sayfalar/girisSayfasi.dart';
import 'package:socialmedia/servisler/yetkilendirmeServisi.dart';

class Yonlendirme extends StatelessWidget {
  const Yonlendirme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeservisi =
        Provider.of<yetkilendirmeServisi>(context, listen: false);

    return StreamBuilder(
      stream: _yetkilendirmeservisi.durumTakipcisi,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        //connectionState : baglantı eger bekleme durumundaysa
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
          //scaffold eklememizin nedeni dönüyor simgesi siyah ekran olarak geliyordu ama scafoldla normal sayfaya düşüyor.
        }
        if (snapshot.hasData) {
          Kullanici aktifKullanici = snapshot.data;
          _yetkilendirmeservisi.aktifKullaniciId = aktifKullanici.id;
          return AnaSayfa();
        } else {
          return GirisSayfasi();
        }
      },
    );
  }
}
