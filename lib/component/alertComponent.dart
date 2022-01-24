
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AlertPosition {
  top,
  center,
  bottom,
}

class Alert {
  static bool _showing = false;
  static OverlayEntry? _overlayEntry;
  static dynamic ctx;

  static triggerStopShowing() {
    _stopShowing(_overlayEntry!);
  }

  static _stopShowing(OverlayEntry overlayEntry) async {
    if(!_showing) {
      return;
    }

    _showing = false;
    overlayEntry.markNeedsBuild();
    await Future.delayed(const Duration(milliseconds: 400));
    overlayEntry.remove();
  }

  static void loading({
    int showingDuration = 1000,                     // unit, millisecond
    AlertPosition position = AlertPosition.center
  }) async {
    Widget loadingWidget = Center(child: Column(children: const [CircularProgressIndicator()]));
    _render(
      ctx, 
      targetWidget: loadingWidget,
      showingDuration: showingDuration,
      position: position
    );
  }

  static void loadingmsg({
    String msg = 'loading',
    int showingDuration = 1000,
    AlertPosition position = AlertPosition.center
  }) async {
    
  Widget loadingmsgWidget = Center(
        child: Opacity(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(msg, 
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
    _render(
      ctx, 
      targetWidget: loadingmsgWidget,
      showingDuration: showingDuration,
      position: position
    );
  }

  static void tips({
    required String msg,
    int showingDuration = 1000,
    Color bgColor = Colors.black,
    Color textColor = Colors.white,
    double textSize = 14.0,
    AlertPosition position = AlertPosition.center,
    double pdHorizontal = 20.0,
    double pdVertical = 10.0,
  }) async {
    Widget tipsWidget = Center(
      child: Column(
        children: [
          Card(
            color: bgColor,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: pdHorizontal,
                vertical: pdVertical
              ),
              child: Text(
                msg,
                style: TextStyle(
                  fontSize: textSize,
                  color: textColor
                ),
              ),
            ),
          )
        ],
      ),
    );
    _render(
      ctx, 
      targetWidget: tipsWidget,
      showingDuration: showingDuration,
      position: position
    );
  }

  static Future<OverlayEntry?> _render(ctx, {
    int showingDuration = 1000,
    AlertPosition position = AlertPosition.center,
    required Widget targetWidget,
  }) async {
    if(_showing) {
      return null;
    }

    OverlayState? overlayState = Overlay.of(ctx);
    if(null != overlayState) {
      DateTime startedTime = DateTime.now();
      _showing = true;
      OverlayEntry overlayEntry = _overlayEntryWidget(ctx, position, targetWidget);
      _overlayEntry = overlayEntry;
      overlayState.insert(overlayEntry);
      await Future.delayed(Duration(milliseconds: showingDuration),(){
        if (DateTime.now().difference(startedTime).inMilliseconds >= showingDuration) {
          _stopShowing(overlayEntry);
        }
      });
      
      return overlayEntry;
    }
    return null;
  }

  static _overlayEntryWidget(ctx, AlertPosition position, Widget targetWidget) {
    double positionTopValue;
    if (position == AlertPosition.top) {
      positionTopValue = MediaQuery.of(ctx).size.height * 1 / 4;
    } else if (position == AlertPosition.center) {
      positionTopValue = MediaQuery.of(ctx).size.height * 2 / 5;
    } else {
      positionTopValue = MediaQuery.of(ctx).size.height * 3 / 4;
    }

    return OverlayEntry(
          builder: (BuildContext context) => Positioned(
            top: positionTopValue,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: AnimatedOpacity(
                  opacity: 0.5
                  , duration: _showing 
                  ? const Duration(microseconds: 100) 
                  : const Duration(microseconds: 300),
                  child: targetWidget
                ),
              ),
            ),
          )
        );
  }
}


