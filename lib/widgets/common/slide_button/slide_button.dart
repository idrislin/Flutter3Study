import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/widgets/common/slide_button/listener.dart';

class BounceStyle {
  final double maxDistance;
  final double k;
  final Duration duration;

  BounceStyle({
    this.duration = const Duration(milliseconds: 200),
    this.maxDistance = 120,
    this.k = 0.8,
  });

  BounceStyle.disable() : this(k: 1);
}

class SlideButton extends StatefulWidget {
  final Widget child;
  final SlideButtonCloseTag? closeTag;
  final bool closeOnPop;
  final bool? opacityChange;
  final VoidCallback? onTap;
  final double buttonWidth;
  final List<Widget> buttons;

  final bool bounce;
  final BounceStyle? bounceStyle;

  BounceStyle get _bounceStyle =>
      bounceStyle ?? (bounce ? BounceStyle() : BounceStyle.disable());

  const SlideButton({
    Key? key,
    required this.child,
    required this.buttons,
    this.closeTag,
    this.onTap,
    this.buttonWidth = 80.0,
    this.closeOnPop = true,
    this.opacityChange,
    this.bounce = false,
    this.bounceStyle,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SlideButtonState();
  }
}

class SlideButtonState extends State<SlideButton>
    with TickerProviderStateMixin {
  double translateX = 0;

  double get bounceTranslate {
    if (widget._bounceStyle.maxDistance == 0) {
      return translateX.clamp(-maxDragDistance, 0.0);
    }
    var resultTranslate = translateX;
    if (resultTranslate < -maxDragDistance) {
      var moreDistance = resultTranslate + maxDragDistance;
      resultTranslate -= moreDistance * widget._bounceStyle.k;
    }
    return min(
        0,
        resultTranslate.clamp(
            -maxDragDistance - widget._bounceStyle.maxDistance, 0.0));
  }

  double get maxDragDistance => widget.buttonWidth * widget.buttons.length;

  double get progress => bounceTranslate / maxDragDistance * -1;

  final Map<Type, GestureRecognizerFactory> gestures =
      <Type, GestureRecognizerFactory>{};

  late AnimationController animationController;

  Map<SlideButtonCloseTag?, Map<Key?, SlideButtonStatus>> get globalMap =>
      SlideButtonListener.instance!.map;

  SlideButtonStatus? get _ct => globalMap[widget.closeTag]![widget.key];

  setCloseListener() {
    if (widget.closeTag == null) return;
    if (globalMap[widget.closeTag] == null) {
      globalMap[widget.closeTag] = {};
    }
    var controller = SlideButtonStatus();
    globalMap[widget.closeTag]![widget.key] = controller;
    globalMap[widget.closeTag]![widget.key]!.addListener(handleChange);
  }

  handleChange() {
    if (globalMap[widget.closeTag]?[widget.key]?.value == null) return;
    if (globalMap[widget.closeTag]?[widget.key]?.value == true) {
      open();
    } else {
      close();
    }
  }

  @override
  void initState() {
    super.initState();
    setCloseListener();
    gestures[HorizontalDragGestureRecognizer] =
        GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
      () => HorizontalDragGestureRecognizer(debugOwner: this),
      (HorizontalDragGestureRecognizer instance) {
        instance
          ..onStart = onHorizontalDragStart
          ..onUpdate = onHorizontalDragUpdate
          ..onEnd = onHorizontalDragEnd;
      },
    );

    gestures[TapGestureRecognizer] =
        GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
      () => TapGestureRecognizer(debugOwner: this),
      (TapGestureRecognizer instance) {
        instance.onTap = widget.onTap;
      },
    );

    animationController = AnimationController(
        value: 0,
        lowerBound: -maxDragDistance - widget._bounceStyle.maxDistance,
        upperBound: 0,
        vsync: this,
        duration: const Duration(milliseconds: 300))
      ..addListener(() {
        translateX = animationController.value;
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(SlideButton oldWidget) {
    if (oldWidget.buttons.length != widget.buttons.length) {
      translateX = 0;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: widget.buttonWidth * widget.buttons.length +
                    widget._bounceStyle.maxDistance,
                child: _WxStyleButtonGroup(
                  opaChange: widget.opacityChange,
                  buttonWidth: widget.buttonWidth,
                  bounceDistance: widget._bounceStyle.maxDistance,
                  progress: progress,
                  children: widget.buttons,
                ),
              ),
            ],
          ),
        ),
        RawGestureDetector(
          gestures: gestures,
          child: Transform.translate(
            offset: Offset(bounceTranslate, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: widget.child,
                )
              ],
            ),
          ),
        )
      ],
    );
    return widget.closeOnPop
        ? WillPopScope(
            child: body,
            onWillPop: () async {
              if (translateX != 0) {
                close();
                return false;
              }
              return true;
            })
        : body;
  }

  void onHorizontalDragStart(DragStartDetails details) {
    if (widget.closeTag == null) return;
    if (_ct!.value == false) {
      SlideButtonListener.instance!
          .needCloseOtherRowOfTag(widget.closeTag, widget.key);
    }
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    translateX += details.delta.dx;

    setState(() {});
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    animationController.value = translateX;
    if (details.velocity.pixelsPerSecond.dx > 200) {
      close();
    } else if (details.velocity.pixelsPerSecond.dx < -200) {
      open(details.velocity.pixelsPerSecond.dx);
    } else {
      if (bounceTranslate.abs() > maxDragDistance / 2) {
        open();
      } else {
        close();
      }
    }
  }

  void open([double v = 0]) async {
    animationController.animateTo(
      -maxDragDistance,
      duration: widget._bounceStyle.duration,
    );
    if (widget.closeTag == null) return;
    _ct!.value = true;
  }

  void close() {
    if (translateX != 0) {
      animationController.animateTo(0);
    }
    if (widget.closeTag == null) return;
    if (_ct!.value == true) {
      _ct!.value = false;
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class _WxStyleButtonGroup extends StatelessWidget {
  final List<Widget>? children;
  final bool? opaChange;
  final double buttonWidth;

  final double? bounceDistance;

  final double progress;

  const _WxStyleButtonGroup({
    Key? key,
    this.children,
    this.buttonWidth = 80,
    this.progress = 0,
    this.opaChange,
    this.bounceDistance,
  }) : super(key: key);

  bool get isOverBounce => progress > 1;

  double get offset => buttonWidth * progress;

  double get eachWidthOffset =>
      (buttonWidth * children!.length + bounceDistance!) /
      children!.length *
      progress;

  @override
  Widget build(BuildContext context) {
    List<Widget> l = [];

    for (var i = 0; i < children!.length; i++) {
      Widget btn = SizedBox(
        width: buttonWidth * progress,
        child: OverflowBox(
          minWidth: buttonWidth,
          maxWidth: double.infinity,
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: isOverBounce ? buttonWidth * progress : buttonWidth,
            child: children![i],
          ),
        ),
      );

      btn = Padding(
        padding: EdgeInsets.only(
          right: offset * i,
        ),
        child: btn,
      );

      if (opaChange == true) {
        btn = Opacity(
          opacity: progress.clamp(0.0, 1.0),
          child: btn,
        );
      }
      l.add(btn);
    }
    return OverflowBox(
      alignment: Alignment.centerLeft,
      minWidth: buttonWidth * children!.length + bounceDistance!,
      maxWidth: buttonWidth * children!.length + bounceDistance!,
      child: Stack(
        alignment: Alignment.centerRight,
        children: l.reversed.toList(),
      ),
    );
  }
}
