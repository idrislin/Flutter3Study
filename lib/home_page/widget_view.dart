import 'package:flutter/material.dart';
import 'package:flutter_study/widgets/common/slide_button/slide_button.dart';

class WidgetsPageView extends StatefulWidget {
  const WidgetsPageView({super.key});

  @override
  State<WidgetsPageView> createState() => _WidgetsPageViewState();
}

class _WidgetsPageViewState extends State<WidgetsPageView> {
  Widget itemWidget(String title, String routerName) {
    return SlideButton(
      bounce: true,
      buttons: const [Text("置顶")],
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, routerName);
        },
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xffE6EBF2),
                width: 0.5,
              ),
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
    return SingleChildScrollView(
      child: Column(
        children: [itemWidget("状态管理", ""), itemWidget("列表", "")],
      ),
    );
  }
}
