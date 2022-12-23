import 'package:flutter/material.dart';
import 'package:flutter_study/home_page/widget_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  final List<SkeletonPage> pages = [
    SkeletonPage(
      pageName: "insight",
      bottomNavigationBarItem: const BottomNavigationBarItem(
        label: '组件',
        icon: SizedBox(
            width: 24,
            height: 24,
            child: (Icon(MdiIcons.widgetsOutline, size: 19))),
        tooltip: "",
      ),
      pageWidget: const WidgetsPageView(),
    ),
    SkeletonPage(
      pageName: "account",
      bottomNavigationBarItem: const BottomNavigationBarItem(
        label: '草稿',
        icon: SizedBox(
            width: 24,
            height: 24,
            child: (Icon(MdiIcons.textBoxOutline, size: 19))),
        tooltip: "",
      ),
      pageWidget: Container(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Node"),
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        children: pages.map((page) => page.pageWidget).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        selectedFontSize: 10,
        enableFeedback: false,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xFFCCCCCC),
        items: pages.map((e) => e.bottomNavigationBarItem).toList(),
        onTap: (i) {
          if (i == _currentIndex) return;
          setState(() => _currentIndex = i);
          _pageController.jumpToPage(_currentIndex);
        },
      ),
    );
  }
}

class SkeletonPage {
  String pageName;
  BottomNavigationBarItem bottomNavigationBarItem;
  Widget pageWidget;

  SkeletonPage(
      {required this.pageName,
      required this.bottomNavigationBarItem,
      required this.pageWidget});
}
