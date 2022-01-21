import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poem/component/toastComponent.dart';
import 'package:flutter_poem/models/NewsListItemModel.dart';
import 'package:flutter_poem/util/poemConstantUtil.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int pageCursor  = 1;
  int pageItemNum = 20;
  bool isPageMore = true;
  List<NewsListItemModel> newsList = [];
  var scrollCtl = ScrollController();
  
  Future<List<NewsListItemModel>> getNewsList() async {
    if(!isPageMore) return [];
    
    HttpClient network = HttpClient();    
    Uri uri = Uri(
        scheme: 'http',
        host: 'api.cportal.cctv.com',
        path: '/api/rest/navListInfo/getHandDataListInfoNew',
        query: 'id=Nav-9Nwml0dIB6wAxgd9EfZA160510&toutuNum=5&version=1&p=$pageCursor&n=$pageItemNum');        
    
    print('Uri: $uri');
    HttpClientRequest request   = await network.getUrl(uri);
    HttpClientResponse response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    Map dataDict = json.decode(responseBody);
    List rawDatas = dataDict['itemList'] as List;
    
    List<NewsListItemModel> models = rawDatas.map((map) {
      map = map as Map;
      NewsListItemModel model = NewsListItemModel.fromDict(map);
      return model;
    }).toList();
      
    return models;
  }

  void requestDataAndReload() async {
    List<NewsListItemModel> models = await getNewsList();
    
    setState(() {
      if(models.length < pageItemNum) isPageMore = false;

      pageCursor++;
      newsList.addAll(models);
    });
  }

  @override
  void initState() {
    super.initState();
  
    requestDataAndReload();

    scrollCtl.addListener(() {
      var _scrollTop    = scrollCtl.position.pixels;
      var _scrollHeight = scrollCtl.position.maxScrollExtent;
      print("scrolltop: $_scrollTop, scrollHeight: $_scrollHeight");
      if(_scrollTop >= _scrollHeight - 20) {
        Timer(const Duration(seconds: 1), () {
          print('homepage context: $context');
          Toast.tips(context, msg: 'Pull down to load more...', position: ToastPostion.bottom);
        });
        requestDataAndReload();
      }
      
    });
  }
  
  Widget _cellContentView(NewsListItemModel model) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(model.title, style: const TextStyle(fontSize: 15.0, color: Color(0xff111111)), maxLines: 3, overflow: TextOverflow.ellipsis),
              Container(
                width: 50.0,
                height: 20.0,
                margin: const EdgeInsets.only(top: 6.0),
                child: ButtonTheme(
                  buttonColor: const Color(0xff1C64CF),
                  shape: const StadiumBorder(),
                  child: RaisedButton(
                    onPressed: () => print('test'),
                    padding: const EdgeInsets.all(2.0),
                    child: const Text(
                      'Listening',
                      style: TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Container(
          height: 85.0,
          width: 115.0,
          margin: const EdgeInsets.only(top: 3.0),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(5.0),
            image: model.imgUrlString.isEmpty ? const DecorationImage(
              image:  AssetImage('images/test.jpg'),
              fit: BoxFit.cover
            ) : DecorationImage (
              image: NetworkImage(model.imgUrlString),
              fit: BoxFit.cover
            )
          ),
        )
      ],
    );
  }

  Future<void> _onRefresh() async {
    print("Draw up to refresh");
    await Future.delayed(
        const Duration(
            milliseconds: 2000), () {
              newsList   = [];
              pageCursor = 1;
              requestDataAndReload();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(      
        title: const Text(PoemConstant.appTitle),
      ),
      body: newsList.length >= pageItemNum ? RefreshIndicator(
        child: ListView.builder(
                  controller: scrollCtl,
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 115.0,
                      child: Column(
                        children: <Widget>[
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0), child: _cellContentView(newsList[index])),
                          Container(margin: const EdgeInsets.only(top: 4.0), color: const Color(0xffeaeaea), constraints: const BoxConstraints.expand(height: 4.0))
                        ],
                      ),
                    );
                  },
                ),
        onRefresh: _onRefresh
      ) : getMoreTips(flag: isPageMore)
    );
  }
}

class getMoreTips extends StatelessWidget {
  var flag = true;
  getMoreTips({Key? key, required this.flag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: flag ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('loading233...'),
          SizedBox(width: 10),
          CircularProgressIndicator(strokeWidth: 2)
        ],
      ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('NoMoreData...'),
            SizedBox(height: 10),
          ],
      ),
    );
  }
}