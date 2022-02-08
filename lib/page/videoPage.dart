import 'package:flutter/material.dart';
import 'package:flutter_aliplayer/flutter_alilistplayer.dart';
import 'package:flutter_aliplayer/flutter_aliplayer_factory.dart';
import 'package:flutter_poem/util/constantUtil.dart';

FocusNode focusNode = new FocusNode();
LayerLink layerLink = new LayerLink();

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);
  @override
  State<VideoPage> createState() => _VideoPage();
}

class _VideoPage extends State<VideoPage> {
  late FlutterAliplayer player;
  late OverlayEntry overlayEntry;
  
  @override
  void initState() {
    super.initState();
    player = FlutterAliPlayerFactory.createAliPlayer();
  }

  @override
  void deactivate() {
    super.deactivate();
    player.stop();
    player.destroy();
  }

  OverlayEntry playsettingOverlay() {
    return OverlayEntry(builder: (context){
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Form(
            child: ListView(
              children: <Widget> [
                TextFormField(decoration: const InputDecoration(labelText: 'test1')),
                const SizedBox(height: Constant.UI_INPUT_ROWHIGHT),
                TextFormField(decoration: const InputDecoration(labelText: 'test2')),
                const SizedBox(height: Constant.UI_INPUT_ROWHIGHT),
                TextFormField(decoration: const InputDecoration(labelText: 'test3')),
                const SizedBox(height: Constant.UI_INPUT_ROWHIGHT),
                RaisedButton(onPressed: (){
                  print('test playersetting overlay');
                }, child: const Text('Play'))
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var x = 0.0;
    var y = 0.0;
    var width  = MediaQuery.of(context).size.width;
    double height;
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      height = width * 9.0 / 16.0;
    } else {
      height = MediaQuery.of(context).size.height;
    }
    AliPlayerView aliPlayerView = AliPlayerView (
        onCreated: (viewId) async {
            player.setPlayerView(viewId);
            player.setUrl("https://m3u8i.vodfile.m1905.com/202202080929/3baa8f1a6b175227af758c0439bf7415/movie/2019/02/18/m20190218P0L0WE6BO6QBAZ7W/90BD33D90325E9DDF1A6F4335.m3u8");
            player.setAutoPlay(true);
            player.prepare();
        },
        x: x,
        y: y,
        width: width,
        height: height
    );    
    
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          body: Column(
            children: [
              Container(
                  color: Colors.black,
                  child: aliPlayerView,
                  width: width,
                  height:height
              ),
            ],
          ),
        );
      },
    );
  }
}