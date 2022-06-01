// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Akis extends StatefulWidget {
  const Akis({Key? key}) : super(key: key);

  @override
  State<Akis> createState() => _AkisState();
}

class _AkisState extends State<Akis> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("akis sayfasi"));
  }
}
