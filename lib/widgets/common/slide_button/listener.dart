import 'package:flutter/material.dart';

class SlideButtonListener {
  factory SlideButtonListener() => _getInstance()!;
  static SlideButtonListener? get instance => _getInstance();
  static SlideButtonListener? _instance;
  SlideButtonListener._internal() {
    //
  }
  static SlideButtonListener? _getInstance() {
    _instance ??= SlideButtonListener._internal();
    return _instance;
  }

  Map<SlideButtonCloseTag?, Map<Key?, SlideButtonStatus>> map = {};

  bool removeListener(SlideButtonCloseTag tag) {
    if (map[tag] != null) {
      map.remove(tag);
      return true;
    }
    return false;
  }

  SlideButtonStatus? targetStatus(SlideButtonCloseTag tag, Key key) =>
      map[tag]![key];

  needCloseOtherRowOfTag(SlideButtonCloseTag? tag, Key? key) {
    if (tag == null) {
      return;
    }
    if (map[tag] == null) {
      return;
    }
    for (var otherKey in map[tag]!.keys) {
      if (otherKey == key) {
        continue;
      }
      if (map[tag]![otherKey]!.value == true) {
        map[tag]![otherKey]!.value = false;
      }
    }
  }
}

class SlideButtonCloseTag {
  final String tag;
  SlideButtonCloseTag(this.tag);

  @override
  int get hashCode => tag.hashCode;

  @override
  operator ==(dynamic other) {
    if (other is SlideButtonCloseTag) {
      if (other.tag == tag) {
        return true;
      }
    }
    return false;
  }
}

class SlideButtonStatus extends ValueNotifier<bool> {
  SlideButtonStatus() : super(false);
  bool get isClose => value;
  bool get isOpen => !value;
}
