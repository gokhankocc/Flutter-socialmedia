// ignore_for_file: prefer_const_constructors, deprecated_member_use, unused_local_variable, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/servisler/firestoreServisi.dart';
import 'package:socialmedia/servisler/storagesevisi.dart';

import '../servisler/yetkilendirmeServisi.dart';

class Yukle extends StatefulWidget {
  const Yukle({Key? key}) : super(key: key);

  @override
  State<Yukle> createState() => _YukleState();
}

class _YukleState extends State<Yukle> {
  File? dosya;
  bool yukleniyor = false;

  TextEditingController aciklamaTextKumandasi = TextEditingController();
  TextEditingController konumTextKumandasi = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return dosya == null ? yukleButonu() : gonderiFormu();
  }

  Widget yukleButonu() {
    return IconButton(
      onPressed: () {
        fotografSec();
      },
      icon: Icon(
        Icons.file_upload,
        size: 50.0,
      ),
    );
  }

  Widget gonderiFormu() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "Gönderi Oluştur",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                dosya = null;
              });
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.black,
              ),
              onPressed: _gonderiolustur)
        ],
      ),
      body: ListView(
        children: <Widget>[
          yukleniyor
              ? LinearProgressIndicator()
              : SizedBox(
                  height: 0.0,
                ),
          AspectRatio(
              aspectRatio: 16.0 / 9.0,
              //aspectRatio : en ve boy oranını ayarlar
              child: Image.file(
                dosya!,
                //bu metoda seçilen veya çekilen fotograf gönderilir
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: aciklamaTextKumandasi,
            decoration: InputDecoration(
              hintText: "Açıklama Ekle",
              contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
              //contentPadding : text alanının içinde boşluk bırakmak için kullanılır
            ),
          ),
          TextFormField(
            controller: konumTextKumandasi,
            decoration: InputDecoration(
              hintText: "Fotoğraf nerede çekildi?",
              contentPadding: EdgeInsets.only(left: 15.0, right: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  void _gonderiolustur() async {
    if (!yukleniyor) {
      setState(() {
        yukleniyor = true;
      });

      String? resimUrl = await StorageServisi().gonderiResmiYukle(dosya!);
      String? aktifkullaniciId =
          Provider.of<yetkilendirmeServisi>(context, listen: false)
              .aktifKullaniciId;

      await firestoreServisi().gonderiOlustur(
          aciklama: aciklamaTextKumandasi.text,
          gonderiResmiUrl: resimUrl,
          konum: konumTextKumandasi.text,
          yayinlayanId: aktifkullaniciId);

      setState(() {
        yukleniyor = false;
        aciklamaTextKumandasi.clear();
        konumTextKumandasi.clear();
        dosya = null;
      });
    }
  }

  fotografSec() {
    return showDialog(
        //kücük bir diyalog penceresi oluşturur
        context: context,
        builder: (context) {
          return SimpleDialog(
            //ana çerçeve başlığı
            title: Text("Gönderi Oluştur"),
            children: <Widget>[
              SimpleDialogOption(
                //option secenek demek zaten
                child: Text("Fotoğraf Çek"),
                onPressed: () {
                  fotoCek();
                },
              ),
              SimpleDialogOption(
                child: Text("Galeriden Yükle"),
                onPressed: () {
                  geleridenSec();
                },
              ),
              SimpleDialogOption(
                child: Text("İptal"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
  //Önemli fotoçek metodunu setstate içinde çalışınca düzgün çalıştıgı için yukarıdaki build metodu bunu gördü ve
  //return dosya == null ? yukleButonu() : gonderiFormu(); yukle butonu yerine gönderiformu metodunu çalıştırdı

  fotoCek() async {
    Navigator.pop(
        context); //yukarıda açılan showDialog penceresinin kapanması için
    var image = await ImagePicker().getImage(
      source: ImageSource.camera,
      //source ile fotografı hangi kaynaktan getirecegimizi söyleriz
      maxWidth: 800, //yuknenecek fotonun max eni
      maxHeight: 600, //yuknenecek fotonun max yuksekigi
      imageQuality: 80, //dosya boyutunu azaltmak için resim kalitesini düşürür.
    );
    setState(() {
      dosya = File(image!.path);
      //yuklenen resmin yolu sadece stringdi file yapıcısına göndererek bir dosya objesi oluşturururz
    });
  }

  geleridenSec() async {
    Navigator.pop(
        context); //yukarıda açılan showDialog penceresinin kapanması için
    var image = await ImagePicker().getImage(
      source: ImageSource.gallery,
      //source ile fotografı hangi kaynaktan getirecegimizi söyleriz
      maxWidth: 800, //yuknenecek fotonun max eni
      maxHeight: 600, //yuknenecek fotonun max yuksekigi
      imageQuality: 80, //dosya boyutunu azaltmak için resim kalitesini düşürür.
    );
    setState(() {
      dosya = File(image!.path);
      //yuklenen resmin yolu sadece stringdi file yapıcısına göndererek bir dosya objesi oluşturururz
    });
  }
}
