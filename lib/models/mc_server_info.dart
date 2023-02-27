class MCServerInfo {
  int? id;
  String displayName;
  String address;

  MCServerInfo(this.displayName, this.address);

  MCServerInfo.fromMap(Map<String, dynamic> json)
      : displayName = json["displayName"],
        address = json["address"] {
          id = json["id"];
        }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "displayName": displayName,
      "address": address,
    };
  }
}
