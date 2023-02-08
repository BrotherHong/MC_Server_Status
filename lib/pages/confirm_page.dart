import 'package:flutter/material.dart';
import 'package:mc_server_status/widgets/mc_button.dart';

class ConfirmPage extends StatelessWidget {
  const ConfirmPage({super.key});

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
            Column(
              children: [
                // space
                Expanded(
                  flex: 2,
                  child: Container(),
                ),

                // text
                const Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "確認刪除?",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ),

                // buttons
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MCButton(
                            text: "確認",
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                          MCButton(
                            text: "取消",
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // space
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
