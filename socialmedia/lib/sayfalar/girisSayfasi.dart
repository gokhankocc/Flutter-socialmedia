// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unused_element, avoid_print, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, empty_catches, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/modeller/kullanici.dart';
import 'package:socialmedia/sayfalar/hesapOlustur.dart';
import 'package:socialmedia/servisler/firestoreServisi.dart';

import '../servisler/yetkilendirmeServisi.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final formAnahtari = GlobalKey<FormState>();
  //formAnahtarı : formun state girmesi için olusturdugumuz anahtar
  final scaffoldAnahtari = GlobalKey<ScaffoldState>();
  //snackbar gösterebilmek için oluşturuyoruz
  bool yukleniyor = false;
  String? email, sifre;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldAnahtari,
      //listview kullanmamızın nedeni aşşadan klavye çıkacak ve çıkan klavye sonucunda giriş alanları yukarı kayması lazım.
      body: Stack(children: [
        sayfalar(),
        _yukleniyoranimasyonu(),
      ]),
    );
  }

  _yukleniyoranimasyonu() {
    if (yukleniyor) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center();
      //boş center döndürmenin herhangi bir etkisi yoktur programa
    }
  }

  Form sayfalar() {
    return Form(
      //form widheti text alanlarına girilen degerleri kontrol etmesi için kullanacagız
      //form'u listvievin dişina ekledik çünkü iki text alanınıda kapsasın diye
      //form widgetinin satatine girim validate ile kontrol yapmamız lazım ama bunu için once anahtar olusturmmız lazım
      key: formAnahtari, //bu anahtarla stateye giriş yapacaz
      child: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 60),
        children: <Widget>[
          FlutterLogo(
            size: 90,
          ),
          SizedBox(
            height: 80,
          ),
          TextFormField(
            //autocorrect : klavyeye birşey yazarken tamamlamamıza yardımcı olur
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "e mail ile giriş",
              errorStyle: TextStyle(fontSize: 16.0),
              //errorstyle : hata mesajının boyutunu belirlemek için kullandık
              prefixIcon: Icon(Icons.mail),
              //prefixIcon : başına simge ekle demek
            ),
            //validator : dogrulayıcı demek kullanıcı bilgilerinin dogrulugunu kontrol etmek için kullanacagız
            validator: (girilendeger) {
              if (girilendeger!.isEmpty) {
                return "e mail alanı boş bırakılamaz";
              } else if (!girilendeger.contains("@")) {
                return "girilen deger mail formatında degildir";
              }
              return null;
            },
            onSaved: (girilendeger) => email = girilendeger,
          ),
          SizedBox(
            height: 40.0,
          ),
          TextFormField(
            obscureText: true, //yazılan yazıları görünmez yapar
            decoration: InputDecoration(
              hintText: "şifre giriniz",
              errorStyle: TextStyle(fontSize: 16.0),
              //errorstyle : hata mesajının boyutunu belirlemek için kullandık
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (girilenDeger) {
              if (girilenDeger!.isEmpty) {
                return "şifre alanı boş bırakılamaz";
              } else if (girilenDeger.trim().length < 4) {
                //buradaki trim boşluk karakterlerini saymaz
                return "şifre dört karakterden az olamaz";
              }
              return null;
            },
            onSaved: (girilendeger) => sifre = girilendeger,
          ),
          SizedBox(
            height: 40.0,
          ),
          Row(
            children: <Widget>[
              //sayfayı tamamen kaplaması için expendet widgeti ekledik
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HesapOlustur()),
                      (route) => true,
                    );
                  },
                  child: Text(
                    "Hesap Oluştur",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: FlatButton(
                  onPressed: _girisYap,
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text("veya"),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: InkWell(
              onTap: _googleIleGirisYap,
              child: Text(
                "Google İle Giriş",
                style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text("şifremi unuttum"),
          ),
        ],
      ),
    );
  }
  /*sayfagec(){
    Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HesapOlustur()),
          (route) => false,
        );
  }*/

  void _girisYap() async {
    final _yetkilendirmeservisi =
        Provider.of<yetkilendirmeServisi>(context, listen: false);
    //formAnahtari.currentState!.validate() : formun içindeki statenin validate
    if (formAnahtari.currentState!.validate()) {
      formAnahtari.currentState!.save(); //onsaved metodlarını çalıştırdık
      //print("data var");
      setState(() {
        yukleniyor = true;
      });
      try {
        await _yetkilendirmeservisi.mailIleGiris(email!, sifre!);
        // Navigator.pop(context);
      } on FirebaseAuthException catch (hata) {
        setState(() {
          yukleniyor = false;
          uyarigoster(hatakodu: hata.code);
        });
      }
    }
  }

  _googleIleGirisYap() async {
    final _yetkilendirmeservisi =
        Provider.of<yetkilendirmeServisi>(context, listen: false);
    setState(() {
      yukleniyor = true;
    });
    try {
      Kullanici? kullanici = await _yetkilendirmeservisi.googleIleGiris();
      if (kullanici != null) {
        Kullanici? firestorekullanici =
            await firestoreServisi().kullaniciGetir(kullanici.id);
        if (firestorekullanici == null) {
          firestoreServisi().kullaniciOlustur(
            id: kullanici.id,
            email: kullanici.eMail,
            fotoUrl: kullanici.fotoUrl,
            kullaniciAdi: kullanici.kullaniciAdi,
          );
          //print("kulanici dokümanı oluşturuldu");
        }
      }
      // Navigator.pop(context);
    } on FirebaseAuthException catch (hata) {
      setState(() {
        yukleniyor = false;
        uyarigoster(hatakodu: hata.code);
      });
    }
  }

  uyarigoster({hatakodu}) {
    String? hataMesaji = "hata var";
    if (hatakodu == "email-already-in-use") {
      hataMesaji = "girdiğiniz e mail kayıtlıdır";
    } else if (hatakodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail geçersizdir";
    } else if (hatakodu == "weak-password") {
      hataMesaji = "Daha zor bir şifre tercih edin";
    } else {
      hataMesaji = "tanımlanamayan bir hata oluştu";
    }
    var snackBar = SnackBar(content: Text(hataMesaji));
    scaffoldAnahtari.currentState!.showSnackBar(snackBar);
    //print(hataMesaji);
  }
}
