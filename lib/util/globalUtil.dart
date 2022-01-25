import 'package:flutter/cupertino.dart';
import 'package:one_context/one_context.dart';

class Global {
  static getContext() {
    return OneContext().context;
  }
}