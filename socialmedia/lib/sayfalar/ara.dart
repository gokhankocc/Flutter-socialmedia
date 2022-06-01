// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';

class Ara extends StatefulWidget {
  const Ara({Key? key}) : super(key: key);

  @override
  State<Ara> createState() => _AraState();
}

class _AraState extends State<Ara> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("arama sayfası"));
  }
}
