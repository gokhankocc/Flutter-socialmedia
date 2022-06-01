// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';

class Duyurular extends StatefulWidget {
  const Duyurular({Key? key}) : super(key: key);

  @override
  State<Duyurular> createState() => _DuyurularState();
}

class _DuyurularState extends State<Duyurular> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("duyurular sayfasi"));
  }
}
