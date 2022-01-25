import 'package:flutter/material.dart';
import 'package:flutter_poem/util/mineRouterUtil.dart';
import 'package:one_context/one_context.dart';

//void main() => runApp(PoemApp());
void main() {
  runApp(const PoemApp());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

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
      builder: OneContext().builder,
      navigatorKey: OneContext().key,
      home: const MineRouter()
    );
  }
}
