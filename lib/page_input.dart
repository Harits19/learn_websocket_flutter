import 'package:fix_issue_websocket/page_test.dart';
import 'package:flutter/material.dart';

class PageWebInput extends StatelessWidget {
  const PageWebInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        body: Center(
          child: TextField(
            controller: controller,
            onEditingComplete: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PageTest(
                    url: controller.text,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
