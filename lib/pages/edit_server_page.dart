import 'package:flutter/material.dart';
import 'package:mc_server_status/models/mc_server.dart';
import 'package:mc_server_status/models/mc_server_info.dart';
import 'package:mc_server_status/widgets/mc_input.dart';

import '../widgets/mc_button.dart';

class EditServerPage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;

  EditServerPage({required MCServerInfo info, super.key})
      : nameController = TextEditingController(text: info.displayName),
        addressController = TextEditingController(text: info.address);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // input body
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MCInput(
                          title: "伺服器名稱",
                          enabled: true,
                          controller: nameController,
                        ),
                        MCInput(
                          title: "伺服器位址",
                          enabled: true,
                          controller: addressController,
                        ),
                      ],
                    ),

                    // space
                    const SizedBox(height: 30),

                    // confirm button
                    MCButton(
                      text: "確認",
                      onPressed: () {
                        Navigator.pop(context, [
                          true,
                          MCServerInfo(nameController.text.trim(),
                              addressController.text.trim())
                        ]);
                      },
                    ),

                    // cancel button
                    MCButton(
                      text: "取消",
                      onPressed: () {
                        Navigator.pop(context, [false]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
