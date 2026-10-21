import 'package:flutter/painting.dart';

abstract final class MonAIRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double mdl = 14;
  static const double lg = 16;
  static const double xl = 18;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double full = 999;
  static const xsAll = BorderRadius.all(Radius.circular(xs));
  static const smAll = BorderRadius.all(Radius.circular(sm));
  static const mdAll = BorderRadius.all(Radius.circular(md));
  static const mdlAll = BorderRadius.all(Radius.circular(mdl));
  static const lgAll = BorderRadius.all(Radius.circular(lg));
  static const xlAll = BorderRadius.all(Radius.circular(xl));
  static const xxlAll = BorderRadius.all(Radius.circular(xxl));
  static const xxxlAll = BorderRadius.all(Radius.circular(xxxl));
  static const fullAll = BorderRadius.all(Radius.circular(full));
  static const sheetTop = BorderRadius.vertical(top: Radius.circular(xxl));
}
