import 'package:flutter/material.dart';
import 'package:mc_server_status/models/mc_server.dart';
import 'package:mc_server_status/models/mc_server_info.dart';
import 'package:mc_server_status/pages/add_server_page.dart';
import 'package:mc_server_status/pages/confirm_page.dart';
import 'package:mc_server_status/pages/edit_server_page.dart';
import 'package:mc_server_status/utils/database_helper.dart';
import 'package:mc_server_status/utils/network.dart';
import 'package:mc_server_status/widgets/mc_button.dart';
import 'package:mc_server_status/widgets/server_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<MCServerInfo> serverInfo = [];

  static Future<List<MinecraftServer>> getFutureServers() async {
    serverInfo = await DatabaseHelper.instance.getServerInfo();

    List<MinecraftServer> servers = [];

    for (int i = 0; i < serverInfo.length; i++) {
      var server = await fetchServer(serverInfo[i].address);
      server.displayName = serverInfo[i].displayName;
      server.address = serverInfo[i].address;
      servers.add(server);
    }

    return servers;
  }

  int selectIndex = -1;
  Future<List<MinecraftServer>> futureServers = getFutureServers();

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
                      return const Text(
                        "Loading...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
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
                            onPressed: editServer,
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
                            onPressed: addServer,
                          ),
                        ),

                        // delete button
                        Expanded(
                          child: MCButton(
                            text: "刪除伺服器",
                            onPressed: deleteServer,
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

  void editServer() async {
    if (selectIndex == -1) return;

    // [confirm, MCServerInfo]
    var data = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditServerPage(info: serverInfo[selectIndex]),
      ),
    );

    bool confirm = data[0];

    if (confirm) {
      MCServerInfo newInfo = data[1];
      if (newInfo.address == "") return;
      await DatabaseHelper.instance.updateServerInfo(serverInfo[selectIndex].id!, newInfo);
      reloadList();
    }
  }

  void reloadList() {
    setState(() {
      futureServers = getFutureServers();
      selectIndex = -1;
    });
  }

  void addServer() async {
    // [confirm, MCServerInfo]
    var data = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddServerPage(),
      ),
    );

    bool confirm = data[0];

    if (confirm) {
      MCServerInfo info = data[1];
      if (info.address == "") return;

      await DatabaseHelper.instance.addServerInfo(info);
      reloadList();
    }
  }

  void deleteServer() async {
    if (selectIndex == -1) return;

    bool confirm = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfirmPage(),
      ),
    );

    if (confirm) {
      await DatabaseHelper.instance.removeServerInfo(serverInfo[selectIndex].id!);
      reloadList();
    }
  }

  ListView buildServerList(List<MinecraftServer> servers) {
    return ListView.builder(
      itemCount: servers.length,
      itemBuilder: (context, index) {
        return ServerTile(
          server: servers[index],
          selected: (index == selectIndex),
          onTap: () => setState(() {
            selectIndex = index;
          }),
        );
      },
    );
  }
}
