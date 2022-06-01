// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_unnecessary_containers, avoid_print, sized_box_for_whitespace, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/servisler/firestoreServisi.dart';
import 'package:socialmedia/servisler/yetkilendirmeServisi.dart';

import '../modeller/kullanici.dart';

class HesapOlustur extends StatefulWidget {
  const HesapOlustur({Key? key}) : super(key: key);

  @override
  State<HesapOlustur> createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  bool yukleniyor = false;
  final formAnahtari = GlobalKey<FormState>();
  final scaffoldAnahtari = GlobalKey<ScaffoldState>();
  String? kullaniciAdi, email, sifre;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldAnahtari,
      appBar: AppBar(title: Text("Hesap Oluştur")),
      body: ListView(
        children: <Widget>[
          yukleniyor ? LinearProgressIndicator() : SizedBox(height: 0.0),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formAnahtari,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    //autocorrect : klavyeye birşey yazarken tamamlamamıza yardımcı olur
                    autocorrect: true,
                    //keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "kullanıcı adı girin",
                      labelText: "kullanıcı adı",
                      errorStyle: TextStyle(fontSize: 16.0),
                      //errorstyle : hata mesajının boyutunu belirlemek için kullandık
                      prefixIcon: Icon(Icons.person),
                      //prefixIcon : başına simge ekle demek
                    ),
                    //validator : dogrulayıcı demek kullanıcı bilgilerinin dogrulugunu kontrol etmek için kullanacagız
                    validator: (girilendeger) {
                      if (girilendeger!.isEmpty) {
                        return "kullanıcı adı boş bırakılamaz";
                      } else if (girilendeger.trim().length < 4 ||
                          girilendeger.trim().length > 10) {
                        return "girilen deger 4 den kucuk 10 dan buyuk olamaz";
                      }
                      return null;
                    },
                    onSaved: (girilenDeger) {
                      kullaniciAdi = girilenDeger;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    //autocorrect : klavyeye birşey yazarken tamamlamamıza yardımcı olur
                    //autocorrect: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "e mail girin",
                      labelText: "mail",
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
                    onSaved: (girilenDeger) {
                      email = girilenDeger;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    obscureText: true, //yazılan yazıları görünmez yapar
                    decoration: InputDecoration(
                      hintText: "şifre oluşturunuz",
                      labelText: "şifre",
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
                    onSaved: (girilenDeger) {
                      sifre = girilenDeger;
                    },
                  ),
                  Container(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: _kullaniciOlustur,
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _kullaniciOlustur() async {
    var _formState = formAnahtari.currentState;
    //yetkilendirme servisini provider ile servisi merkezileştirmek için kullandık
    final _yetkilendirmeservisi =
        Provider.of<yetkilendirmeServisi>(context, listen: false);
    if (_formState!.validate()) {
      _formState.save(); //vaidatörun onsaved metodundan geliyor

      setState(() {
        yukleniyor = true;
      });
      try {
        Kullanici? kullanici =
            await _yetkilendirmeservisi.mailIleKayit(email!, sifre!);
        if (kullanici != null) {
          //giriş işlemi başarılı demektir
          firestoreServisi().kullaniciOlustur(
              id: kullanici.id, email: email, kullaniciAdi: kullaniciAdi);
        }
        Navigator.pop(context);
      } on FirebaseAuthException catch (hata) {
        setState(() {
          yukleniyor = false;
        });
        print("hata");
        print(hata);
        uyarigoster(hatakodu: hata.code);
      }
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


/*email-already-in-use:
Thrown if there already exists an account with the given email address.
invalid-email:
Thrown if the email address is not valid.
operation-not-allowed:
Thrown if email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.
weak-password:
Thrown if the password is not strong enough. */