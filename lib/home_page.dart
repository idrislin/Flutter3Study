import 'package:flutter/material.dart';
import 'package:flutter_study/widgets/common/slide_button/slide_button.dart';

const curriculum = ["状态管理"];

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  Widget itemWidget(String title) {
    return SlideButton(
      bounce: true,
      buttons: const [Text("置顶")],
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffE6EBF2), width: 0.5),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Text(title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Node"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: curriculum.map((e) => itemWidget(e)).toList(),
        ),
      ),
    );
  }
}
