import 'package:flutter/material.dart';
import 'package:flutter_aliplayer/flutter_alilistplayer.dart';
import 'package:flutter_aliplayer/flutter_aliplayer_factory.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);
  @override
  State<VideoPage> createState() => _VideoPage();
}

class _VideoPage extends State<VideoPage> {
  late FlutterAliplayer player;
  
  @override
  void initState() {
    super.initState();
    player = FlutterAliPlayerFactory.createAliPlayer();
  }

  @override
  Widget build(BuildContext context) {
    var x = 0.0;
    var y = 0.0;
    var width = MediaQuery.of(context).size.width;

    var height = MediaQuery.of(context).size.height;
    AliPlayerView aliPlayerView = AliPlayerView(
        onCreated: onViewPlayerCreated,
        x: x,
        y: y,
        width: width,
        height: height);
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          body: Column(
            children: [
              Container(
                  color: Colors.black,
                  child: aliPlayerView,
                  width: width,
                  height: height),
            ],
          ),
        );
      },
    );
  }

    void onViewPlayerCreated(viewId) async {
    //将渲染View设置给播放器
    player.setPlayerView(viewId);
    //设置播放源，URL播放方式
    player.setUrl("https://m3u8i.vodfile.m1905.com/202201300615/8a2780bac9dcf018764c3eb69cd8dae0/movie/2019/02/18/m20190218P0L0WE6BO6QBAZ7W/90BD33D90325E9DDF1A6F4335.m3u8");
    //开启自动播放
    player.setAutoPlay(true);
    player.prepare();
  }
  
}