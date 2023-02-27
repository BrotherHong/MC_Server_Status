import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mc_server_status/models/mc_server_info.dart';

class MinecraftServer {
  static final _defaultIcon = Image.asset(
    "assets/images/no_icon.png",
    fit: BoxFit.fill,
  );

  String address = "a";
  bool online = false;
  String displayName = "";
  String motd1 = "";
  String motd2 = "";
  int currPlayer = 0;
  int maxPlayer = 0;

  Image serverIcon = _defaultIcon;

  get iconImage {
    if (!online) {
      return _defaultIcon;
    }

    return serverIcon;
  }

  MinecraftServer.loading() {
    online = false;
    displayName = "Minecraft Server";
    motd1 = "Loading...";
    motd2 = "Loading...";
  }

  MinecraftServer.fromJson(Map<String, dynamic> json) {
    online = json["online"];

    if (!online) return;

    if ((json["motd"]["raw"] as List<dynamic>).isNotEmpty) {
      motd1 = json["motd"]["raw"][0];
    }

    if ((json["motd"]["raw"] as List<dynamic>).length == 2) {
      motd2 = json["motd"]["raw"][1];
    }

    // data:image/png;base64, -> len == 22
    String iconBASE64 = (json["icon"] as String).substring(22);

    if (iconBASE64 != "") {
      serverIcon = Image.memory(
        base64Decode(iconBASE64),
        fit: BoxFit.fill,
      );
    }

    currPlayer = json["players"]["online"];
    maxPlayer = json["players"]["max"];
  }
}
