- [Flutter 3.0 study](#flutter-30-study)
  - [State Controller](#state-controller)
    - [setState](#setstate)
    - [InheritedWidget](#inheritedwidget)

# Flutter 3.0 study

## State Controller

### setState

当 widget 状态需要发生更改，可以使用 setState 对 widget 及其所有子 widget 重新构建。当组件只需要在当前 widget 且不需要向下或者向上传递时，setState 是最适合的状态管理。

setState 源码

```dart
void setState(VoidCallback fn) {
    _element.markNeedsBuild();
}
```

//TODO: 刷新机制及原理

> tip： 会触发组件的 build()

### InheritedWidget

widget 树从上到下共享状态。在根 widget 通过 InheritedWidget 共享了一个状态，则在其 widget 的所有子树都能一样享有该状态。Flutter SDK 主题（theme）和语言环境（locale）就是使用 InheritedWidget 共享。

> tip： 会触发子组件的 didChangeDependencies()
