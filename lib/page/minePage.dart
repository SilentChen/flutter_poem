import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poem/util/constantUtil.dart';
import 'package:flutter_poem/util/dioHandlerUtil.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override  
  State<MinePage> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      DioHandler.get('http://www.baidu.com');
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(      
        title: const Text(Constant.appTitle),
      ),
      body: Center(
        child: Column(         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
}