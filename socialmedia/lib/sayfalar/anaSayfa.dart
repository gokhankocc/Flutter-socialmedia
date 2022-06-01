// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_call_super, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/sayfalar/akis.dart';
import 'package:socialmedia/sayfalar/ara.dart';
import 'package:socialmedia/sayfalar/profil.dart';
import 'package:socialmedia/sayfalar/yukle.dart';
import 'package:socialmedia/servisler/yetkilendirmeServisi.dart';

import 'duyurular.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _aktifNo = 0;
  PageController? sayfaKumandasi;
  @override
  void initState() {
    sayfaKumandasi = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    sayfaKumandasi!
        .dispose(); //dispose ile aktif olan controllerları kapatırız çünkü bellekte yer kaplar. super den önce yazılmalıdır dikkat!!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? aktifkullaniciIdi =
        Provider.of<yetkilendirmeServisi>(context, listen: false)
            .aktifKullaniciId;
    return Scaffold(
      //pageView : içerisine eklenen widgetların ayrı birir sayfa gibi görünmesini saglar
      body: PageView(
          physics:
              NeverScrollableScrollPhysics(), //sayfanın kaydırılma özelliğini kapatır,
          onPageChanged: (acilanSayfaNo) {
            setState(() {
              //kaydırma yapınca alt panel degişecek
              _aktifNo = acilanSayfaNo;
            });
          },
          controller: sayfaKumandasi,
          children: <Widget>[
            Akis(),
            Ara(),
            Yukle(),
            Duyurular(),
            Profil(profilSahibiId: aktifkullaniciIdi),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktifNo, //sayfa ilk açıldıgında akış seçili olacak
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Akış"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Keşfet"),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_upload), label: "Yükle"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Duyurular"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
        onTap: (secilenSayfaNo) {
          setState(() {
            _aktifNo = secilenSayfaNo;
            sayfaKumandasi!.jumpToPage(secilenSayfaNo);
            //jumptopage : sayfa altındaki hangi butona tıklarsak ona ait sayfayi getirir.
          });
        },
      ),
    );
  }
}
