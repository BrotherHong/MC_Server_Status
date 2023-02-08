import 'package:flutter/material.dart';

class MCInput extends StatelessWidget {
  final String title;
  final bool enabled;
  final TextEditingController controller;

  const MCInput(
      {required this.title,
      required this.enabled,
      required this.controller,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),

          // text field
          TextField(
            controller: controller,
            enabled: enabled,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black,
              enabledBorder: getInputBorder(),
              focusedBorder: getInputBorder(),
              disabledBorder: getInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder getInputBorder() {
    return const OutlineInputBorder(
      gapPadding: 0,
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 169, 163, 163),
        width: 4,
      ),
    );
  }
}
