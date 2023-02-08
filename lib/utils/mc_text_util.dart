import 'package:flutter/material.dart';

final _colorMap = {
  "0": const Color.fromRGBO(0x00, 0x00, 0x00, 1),
  "1": const Color.fromRGBO(0x00, 0x00, 0xAA, 1),
  "2": const Color.fromRGBO(0x00, 0xAA, 0x00, 1),
  "3": const Color.fromRGBO(0x00, 0xAA, 0xAA, 1),
  "4": const Color.fromRGBO(0xAA, 0x00, 0x00, 1),
  "5": const Color.fromRGBO(0xAA, 0x00, 0xAA, 1),
  "6": const Color.fromRGBO(0xFF, 0xAA, 0x00, 1),
  "7": const Color.fromRGBO(0xAA, 0xAA, 0xAA, 1),
  "8": const Color.fromRGBO(0x55, 0x55, 0x55, 1),
  "9": const Color.fromRGBO(0x55, 0x55, 0xFF, 1),
  "a": const Color.fromRGBO(0x55, 0xFF, 0x55, 1),
  "b": const Color.fromRGBO(0x55, 0xFF, 0xFF, 1),
  "c": const Color.fromRGBO(0xFF, 0x55, 0x55, 1),
  "d": const Color.fromRGBO(0xFF, 0x55, 0xFF, 1),
  "e": const Color.fromRGBO(0xFF, 0xFF, 0x55, 1),
  "f": const Color.fromRGBO(0xFF, 0xFF, 0xFF, 1),
};

class MCTextUtil {
  static Text colorize(String str, double fontSize) {
    final content = <InlineSpan>[];
    final int colorCode = "\u00a7".codeUnitAt(0);

    const String keyCode = "0123456789abcdeflomnr#";

    var text = _MCText();

    for (int i = 0; i < str.length; i++) {
      bool skip = false; // flag

      // check if it is format code
      if (str.codeUnitAt(i) == colorCode && i + 1 < str.length) {
        int next = str.codeUnitAt(i+1);

        if (text.str != "") {
          content.add(text.getTextSpan(fontSize));
          text.reset();
        }

        if (keyCode.contains(String.fromCharCode(next))) {
          String code = String.fromCharCode(next);

          skip = true;
          switch (code) {
            case "l":
              text.bold = true;
              break;
            case "o":
              text.italic = true;
              break;
            case "m":
              text.lineThrough = true;
              break;
            case "n":
              text.underline = true;
              break;
            case "r":
              text.reset();
              break;
            case "#":
              if (i+7 < str.length) {
                String sub = str.substring(i+2, i+7+1);
                if (sub.contains(RegExp(r"^[0-9,a-f,A-F]{6}$"))) {
                  text.color = Color(0xFF000000 + int.parse(sub, radix: 16));
                  i += 6;
                } else {
                  skip = false;
                }
              }
              break;
            default:
              text.color = _colorMap[code]!;
          }
        }

      }

      // it is format code
      if (skip) {
        i++;
        continue;
      }

      // update current string
      text.str += String.fromCharCode(str.codeUnitAt(i));
    }

    // put last
    content.add(text.getTextSpan(fontSize));

    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 10,
          fontFamily: "Minecraft",
        ),
        children: content,
      ),
    );
  }
}

class _MCText {
  String str = "";
  Color color = _colorMap["f"]!;
  bool bold = false; // l
  bool italic = false; // o
  bool lineThrough = false; // m
  bool underline = false; // n

  void reset() {
    str = "";
    color = _colorMap["f"]!;
    bold = italic = lineThrough = underline = false;
  }

  TextSpan getTextSpan(double fontSize) {
    return TextSpan(
      text: str,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        decoration: TextDecoration.combine([
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
          underline ? TextDecoration.underline : TextDecoration.none,
        ]),
      ),
    );
  }
}

/*
                \u00a7aHypixel Network \u00a7c[1.8-1.19]
   \u00a7c\u00a7lLUNAR MAPS \u00a77\u00a7l\u00a7 \u00a76\u00a7lCOSMETICS \u00a77| \u00a7d\u00a7lSKYBLOCK 0.17.3

l : bold
m : line through
n : underline
o : italic
-
r : reset
k : obfuscated

&r&7  &r&6\u5ee2\u571f\u4f3a\u670d\u5668 &r&fmcFallout.net&r&8 - &r&f\u7248\u672c 1.19.2 &r&#035a61&l\u8352\u91ce&r&#8ac376&l\u66f4\u65b0
*/