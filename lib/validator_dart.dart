/// Support for doing something awesome.
///
/// More dartdocs go here.
library validator_dart;

import 'package:validator_dart/src/validators/blacklist.dart';
import 'package:validator_dart/src/validators/escape.dart';
import 'package:validator_dart/src/validators/ltrim.dart';
import 'package:validator_dart/src/validators/rtrim.dart';
import 'package:validator_dart/src/validators/to_boolean.dart';
import 'package:validator_dart/src/validators/to_float.dart';
import 'package:validator_dart/src/validators/to_int.dart';
import 'package:validator_dart/src/validators/trim.dart';
import 'package:validator_dart/src/validators/unescape.dart';

class Validator {
  Validator._();

  static bool toBoolean(dynamic str, bool? strict) => $toBoolean(str, strict);
  static String ltrim(dynamic str, String? chars) => $ltrim(str, chars);
  static String rtrim(dynamic str, String? chars) => $rtrim(str, chars);
  static String trim(dynamic str, String? chars) => $trim(str, chars);
  static int? toInt(dynamic str, {int? radix = 10}) =>
      $toInt(str, radix: radix);
  static double toFloat(dynamic str) => $toFloat(str);
  static String escape(dynamic str) => $escape(str);
  static String unescape(dynamic str) => $unescape(str);
  static String blacklist(dynamic str, String chars) => $blacklist(str, chars);
}
