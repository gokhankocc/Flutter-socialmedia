// ignore_for_file: unnecessary_null_comparison, unused_element, camel_case_types, unused_local_variable, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialmedia/modeller/kullanici.dart';

class yetkilendirmeServisi {
  //auttantication servisi oluşturma
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? aktifKullaniciId;

  Kullanici? _kullaniciOlustur(User? kullanici) {
    return kullanici == null ? null : Kullanici.firebasedenUret(kullanici);
  }

  Stream<Kullanici?> get durumTakipcisi {
    return _firebaseAuth.authStateChanges().map(_kullaniciOlustur);
  }

  Future<Kullanici?> mailIleKayit(String email, String password) async {
    var girisKarti = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return _kullaniciOlustur(girisKarti.user);
    //giriş karti içindeki user kullanıcısını _kullanıcıolustur metoduna göndererek kullanıcı objesi oluştururuz.
  }

  Future<Kullanici?> mailIleGiris(String email, String password) async {
    var girisKarti = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return _kullaniciOlustur(girisKarti.user);
    //giriş karti içindeki user kullanıcısını _kullanıcıolustur metoduna göndererek kullanıcı objesi oluştururuz.
  }

  Future<void> cikisYap() {
    return _firebaseAuth.signOut();
  }

  Future<Kullanici?> googleIleGiris() async {
    GoogleSignInAccount? googlehesabi = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleyetkikartim =
        await googlehesabi!.authentication;
    AuthCredential sifresizGirisBelgesi = GoogleAuthProvider.credential(
        accessToken: googleyetkikartim.accessToken,
        idToken: googleyetkikartim.idToken);
    UserCredential girisKarti =
        await _firebaseAuth.signInWithCredential(sifresizGirisBelgesi);
    return _kullaniciOlustur(girisKarti.user);
  }
}
