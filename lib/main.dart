import 'package:flutter/material.dart';
import 'package:flutter_poem/util/poemRouter.dart';

//void main() => runApp(PoemApp());
void main() {
  runApp(const PoemApp());
}

class PoemApp extends StatelessWidget {
  const PoemApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poem',
      theme: ThemeData(        
        primarySwatch: Colors.blue,
      ),
      home: const PoemRouter()
    );
  }
}
