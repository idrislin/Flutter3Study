import 'package:flutter/material.dart';
import 'package:flutter_study/widgets/list/list.dart';
import 'package:flutter_study/widgets/state/set_state/set_state_page.dart';

class Router {
  static const String listWidget = "/list-widget";
  static const String stateWidget = "/state-widget";

  Map<String, WidgetBuilder> routes = {
    listWidget: (context) => const ListWidget(),
    stateWidget: (context) => const StateLearnPage(),
  };
}
