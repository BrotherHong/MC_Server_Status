import 'package:flutter/material.dart';
import 'package:mc_server_status/models/mc_server.dart';
import 'package:mc_server_status/utils/mc_text_util.dart';

class ServerTile extends StatefulWidget {

  final MinecraftServer server;
  final void Function()? onTap;

  bool selected = false;

  ServerTile({required this.server, required this.selected, required this.onTap, super.key});

  @override
  State<ServerTile> createState() => _ServerTileState();
}

class _ServerTileState extends State<ServerTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector (
      // on one tap (select)
      onTap: widget.onTap,

      // on double tap (see detail)
      onDoubleTap: () {
        
      },

      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        // background
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black45,
            border: widget.selected
                ? Border.all(color: Colors.white.withOpacity(0.5), width: 2)
                : Border.all(color: Colors.black45, width: 2),
          ),
          child: Row(
            children: [
              // server icon
              SizedBox(
                width: 64,
                height: 64,
                child: widget.server.iconImage,
              ),
      
              // informations
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 64,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Minecraft Server
                          Expanded(
                            child: Text(
                              widget.server.displayName,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
      
                          // Players
                          Text(
                            "${widget.server.currPlayer}/${widget.server.maxPlayer}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
      
                          // Ping icon
                          Icon(
                            widget.server.online
                                ? Icons.signal_cellular_alt
                                : Icons
                                    .signal_cellular_connected_no_internet_0_bar,
                            color: widget.server.online ? Colors.green : Colors.red,
                            size: 18,
                          ),
                        ],
                      ),
      
                      // motd
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              // Line 1
                              Expanded(
                                child: SizedBox.expand(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: MCTextUtil.colorize(widget.server.motd1, 11),
                                  ),
                                ),
                              ),
      
                              // Line 2
                              Expanded(
                                child: SizedBox.expand(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: MCTextUtil.colorize(widget.server.motd2, 11),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
