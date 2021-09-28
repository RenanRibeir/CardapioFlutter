//--no-sound-null-safety

import 'package:flutter/material.dart';
import 'package:menuautoatendimento/pages/ItemsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: ItemsPage(),
    );
  }
}
