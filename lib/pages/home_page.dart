import 'package:flutter/material.dart';
import 'package:mc_server_status/models/mc_server.dart';
import 'package:mc_server_status/pages/add_server_page.dart';
import 'package:mc_server_status/pages/confirm_page.dart';
import 'package:mc_server_status/utils/network.dart';
import 'package:mc_server_status/widgets/mc_button.dart';
import 'package:mc_server_status/widgets/server_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final List<List<String>> addresses = [];

  int selectIndex = -1;

  Future<List<MinecraftServer>> futureServers = getFutureServers(addresses);

  static Future<List<MinecraftServer>> getFutureServers(
      List<List<String>> address) async {
    List<MinecraftServer> servers = [];

    for (int i = 0; i < address.length; i++) {
      var server = await fetchServer(address[i][1]);
      server.name = address[i][0];
      server.address = address[i][1];
      servers.add(server);
    }

    return servers;
  }

  void reloadList() {
    setState(() {
      futureServers = getFutureServers(addresses);
      selectIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/dirt_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // main layer
          Column(
            children: [
              // Top Title Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                ),
                child: const Text(
                  "Minecraft Server List",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                  ),
                ),
              ),

              // Server List
              Expanded(
                child: FutureBuilder<List<MinecraftServer>>(
                  future: futureServers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          return ServerTile(
                            server: MinecraftServer.loading(),
                            selected: false,
                          );
                        },
                      );
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        var servers = snapshot.data!;

                        return buildServerList(servers);
                      }

                      if (snapshot.hasError) {
                        return Text(
                          snapshot.error.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        );
                      }
                    }

                    throw Exception("Shouldn't be reached");
                  },
                ),
              ),

              // Buttons
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // edit button
                        Expanded(
                          child: MCButton(
                            text: "編輯",
                            onPressed: () {},
                          ),
                        ),

                        // refresh button
                        Expanded(
                          child: MCButton(
                            text: "重新整理",
                            onPressed: reloadList,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // new server button
                        Expanded(
                          child: MCButton(
                            text: "新增伺服器",
                            onPressed: () async {
                              var data = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddServerPage(),
                                ),
                              );

                              setState(() {
                                if (data[0] && data[2] != "") {
                                  addresses.add([data[1], data[2]]);
                                  reloadList();
                                }
                                selectIndex = -1;
                              });
                            },
                          ),
                        ),

                        // delete button
                        Expanded(
                          child: MCButton(
                            text: "刪除伺服器",
                            onPressed: () async {
                              if (selectIndex == -1) return;

                              var confirm = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ConfirmPage(),
                                ),
                              );

                              setState(() {
                                if (confirm != null &&
                                    confirm is bool &&
                                    confirm) {
                                  addresses.removeAt(selectIndex);
                                  reloadList();
                                }
                                selectIndex = -1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListView buildServerList(List<MinecraftServer> servers) {
    return ListView.builder(
      itemCount: servers.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => setState(() {
            selectIndex = index;
          }),
          child: ServerTile(
            server: servers[index],
            selected: (index == selectIndex),
          ),
        );
      },
    );
  }
}
