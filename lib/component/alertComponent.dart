
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

//alert 显示位置控制 
enum AlertPostion {
  top,
  center,
  bottom,
}

class Alert {
  // alert靠它加到屏幕上
  static late OverlayEntry _overlayEntry;
  // alert是否正在showing
  static bool _showing = false;
  // 开启一个新alert的当前时间，用于对比是否已经展示了足够时间
  static late DateTime _startedTime;
  // 提示内容
  static late String _msg;
  // alert显示时间
  static late int _showTime;
  // 背景颜色
  static late Color _bgColor;
  // 文本颜色
  static late Color _textColor;
  // 文字大小
  static late double _textSize;
  // 显示位置
  static late AlertPostion _alertPosition;
  // 左右边距
  static late double _pdHorizontal;
  // 上下边距
  static late double _pdVertical;

  static triggerStopShowing() async {
    if(!_showing) {
      return;
    }

    _showing = false;
    _overlayEntry.markNeedsBuild();
    await Future.delayed(const Duration(milliseconds: 400));
    _overlayEntry.remove();
    //_overlayEntry = null as OverlayEntry;
  }

  static void loading(BuildContext context, {
    int showTime = 1000,
    AlertPostion position = AlertPostion.center
  }) async {
    if(_showing) return;
    
    _startedTime = DateTime.now();
    _showTime = showTime;
    _alertPosition = position;

    OverlayState? overlayState = Overlay.of(context);
    _showing = true;

    _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
                //top值，可以改变这个值来改变alert在屏幕中的位置
                top: calcPosition(context),
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: AnimatedOpacity(
                        opacity: _showing ? 1.0 : 0.0, //目标透明度
                        duration: _showing
                            ? const Duration(milliseconds: 100)
                            : const Duration(milliseconds: 300),
                        child: _buildLoadingWidget(),
                      ),
                    )),
              ));
      //插入到整个布局的最上层
    overlayState!.insert(_overlayEntry);
    await Future.delayed(Duration(milliseconds: _showTime));
    //2秒后 到底消失不消失
    if (DateTime.now().difference(_startedTime).inMilliseconds >= _showTime) {
      triggerStopShowing();
    }

  }

  static void loadingmsg(BuildContext context, {
    String msg = 'loading',
    int showTime = 1000,
    AlertPostion position = AlertPostion.center
  }) async {
    if(_showing) return;
    
    _msg = msg;
    _startedTime = DateTime.now();
    _showTime = showTime;
    _alertPosition = position;

    OverlayState? overlayState = Overlay.of(context);
    _showing = true;

    _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
                //top值，可以改变这个值来改变alert在屏幕中的位置
                top: calcPosition(context),
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: AnimatedOpacity(
                        opacity: _showing ? 1.0 : 0.0, //目标透明度
                        duration: _showing
                            ? const Duration(milliseconds: 100)
                            : const Duration(milliseconds: 300),
                        child: _buildLoadingMsgWidget(),
                      ),
                    )),
              ));
      //插入到整个布局的最上层
    overlayState!.insert(_overlayEntry);
    await Future.delayed(Duration(milliseconds: _showTime));
    //2秒后 到底消失不消失
    if (DateTime.now().difference(_startedTime).inMilliseconds >= _showTime) {
      triggerStopShowing();
    }

  }

  static void tips(
    BuildContext context, {
    //显示的文本
    required String msg,
    //显示的时间 单位毫秒
    int showTime = 1000,
    //显示的背景
    Color bgColor = Colors.black,
    //显示的文本颜色
    Color textColor = Colors.white,
    //显示的文字大小
    double textSize = 14.0,
    //显示的位置
    AlertPostion position = AlertPostion.center,
    //文字水平方向的内边距
    double pdHorizontal = 20.0,
    //文字垂直方向的内边距
    double pdVertical = 10.0,
  }) async {
    if(_showing) return;

    //assert(msg != null);
    _msg = msg;
    _startedTime = DateTime.now();
    _showTime = showTime;
    _bgColor = bgColor;
    _textColor = textColor;
    _textSize = textSize;
    _alertPosition = position;
    _pdHorizontal = pdHorizontal;
    _pdVertical = pdVertical;
    //获取OverlayState
    OverlayState? overlayState = Overlay.of(context);
    _showing = true;

    //if (null == _overlayEntry) {
      //print('context: $context, overlayState: $overlayState');
      //OverlayEntry负责构建布局
      //通过OverlayEntry将构建的布局插入到整个布局的最上层
      _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
                //top值，可以改变这个值来改变alert在屏幕中的位置
                top: calcPosition(context),
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: AnimatedOpacity(
                        opacity: _showing ? 1.0 : 0.0, //目标透明度
                        duration: _showing
                            ? const Duration(milliseconds: 100)
                            : const Duration(milliseconds: 300),
                        child: _buildTipsWidget(),
                      ),
                    )),
              ));
      //插入到整个布局的最上层
      overlayState!.insert(_overlayEntry);
    //} else {
      //重新绘制UI，类似setState
    //  _overlayEntry.markNeedsBuild();
    //}
    // 等待时间
    await Future.delayed(Duration(milliseconds: _showTime));
    //2秒后 到底消失不消失
    if (DateTime.now().difference(_startedTime).inMilliseconds >= _showTime) {
      triggerStopShowing();
      
    }
  }

  static _buildLoadingWidget() {
    return Center(
      child: Column(
        children: const [
          CircularProgressIndicator()
        ],
      ),
    );
  }

  static _buildLoadingMsgWidget() {
    return Center(
      child: Opacity(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_msg, 
              style: const TextStyle(
                fontSize: 16, 
                color: Colors.black, 
                fontWeight: FontWeight.normal, 
                decoration: TextDecoration.none
              )
            ),
            const SizedBox(width: 10),
            const CircularProgressIndicator(strokeWidth: 2)
          ],
        ),
        opacity: 0.5,
      ),
    );
  }

  //alert绘制
  static _buildTipsWidget() {

    return Center(
      child: Column(
        children: [
          Card(
            color: _bgColor,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: _pdHorizontal, vertical: _pdVertical),
              child: Text(
                _msg,
                style: TextStyle(
                  fontSize: _textSize,
                  color: _textColor,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

//  设置alert位置
  static calcPosition(context) {

    var backResult;
    if (_alertPosition == AlertPostion.top) {
      backResult = MediaQuery.of(context).size.height * 1 / 4;
    } else if (_alertPosition == AlertPostion.center) {
      backResult = MediaQuery.of(context).size.height * 2 / 5;
    } else {
      backResult = MediaQuery.of(context).size.height * 3 / 4;
    }
    return backResult;
  }
}


