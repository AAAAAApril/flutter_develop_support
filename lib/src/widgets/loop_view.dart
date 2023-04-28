import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

///循环滚动的视图
///
/// (0) 0 (0)
/// 0 1 2
///
/// (1) 0 1 (0)
/// 0 1 2 3
///
/// (2) 0 1 2 (0)
/// 0 1 2 3 4
///
/// (3) 0 1 2 3 (0)
/// 0 1 2 3 4 5
///
class LoopView extends StatefulWidget {
  const LoopView({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.pageController,
    this.scrollDirection = Axis.horizontal,
  })  : assert(itemCount >= 0),
        super(key: key);

  final LoopController? controller;

  ///页面数量（数据数量）
  final int itemCount;

  ///页面构建器（与数据对应）
  final IndexedWidgetBuilder itemBuilder;

  ///页面控制器
  final LoopPageController? pageController;

  ///滚动方向
  final Axis scrollDirection;

  @override
  State<LoopView> createState() => _LoopViewState();
}

class _LoopViewState extends State<LoopView> {
  ///真实 itemCount
  late int realItemCount;

  ///页面控制器
  late LoopPageController pageController;

  ///控制器
  late LoopController controller;

  ///真实滚动下标
  late int currentRealIndex;

  @override
  void initState() {
    super.initState();
    //如果不为空，则 +2 ，否则不变
    realItemCount = LoopController.itemCount2RealCount(widget.itemCount);

    pageController = widget.pageController ??
        LoopController.obtainPageController(
          itemCount: widget.itemCount,
        );

    currentRealIndex =
        widget.itemCount > 0 ? pageController.initialPage - 1 : 0;

    controller = widget.controller ?? LoopController();
    controller._pageController = pageController;

    controller._onPageChanged.value = LoopController.realIndex2DataIndex(
      itemCount: widget.itemCount,
      realIndex: pageController.initialPage,
    );

    controller.startAutoPlay();
  }

  @override
  void dispose() {
    controller._pageController = null;
    controller._autoPlayTimer?.cancel();
    if (widget.controller == null) {
      controller.dispose();
    }
    if (widget.pageController == null) {
      pageController.dispose();
    }
    super.dispose();
  }

  ///是否有数据
  bool get hasItem => realItemCount >= 3;

  ///滚动监听
  ///用户操作滚动时回调顺序：start -> user ... end -> user
  bool onScrollNotification(ScrollNotification notification) {
    //滚动开始
    if (notification is ScrollStartNotification) {
      controller._scrolling.value = true;
    }
    //用户操作滚动
    else if (notification is UserScrollNotification) {
      //正在滚动
      if (controller._scrolling.value) {
        controller._userGesture.value = true;
        // 用户在操作时，需要停止自动滚动
        if (hasItem) {
          controller.stopAutoPlay();
        }
      }
      //滚动结束了
      else {
        controller._userGesture.value = false;
        // 用户操作结束，需要开启自动滚动
        if (hasItem) {
          controller.startAutoPlay();
        }
      }
    }
    //滚动结束
    else if (notification is ScrollEndNotification) {
      controller._scrolling.value = false;
    }
    return false;
  }

  ///页面切换变更
  void onPageChanged(int newIndex) {
    currentRealIndex = newIndex;
    controller._onPageChanged.value = LoopController.realIndex2DataIndex(
      itemCount: widget.itemCount,
      realIndex: newIndex,
    );
    if (hasItem) {
      //停在第一个的时候，需要重置到倒数第二个
      if (currentRealIndex == 0) {
        //重置到倒数第二个
        _delay2Target(realItemCount - 2);
      }
      //停在最后一个的时候，需要重置到第二个
      else if (currentRealIndex == realItemCount - 1) {
        //重置到第二个
        _delay2Target(1);
      }
    }
  }

  void _delay2Target(int targetIndex) {
    //这个延迟是为了避免显示卡顿（具体数值可能需要调整）
    Future.delayed(
      Duration(
        microseconds: (controller.scrollDuration.inMicroseconds / 2).ceil(),
      ),
      () {
        pageController.jumpToPage(targetIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: onScrollNotification,
      child: PageView.builder(
        controller: pageController,
        itemCount: realItemCount,
        scrollDirection: widget.scrollDirection,
        itemBuilder: (context, index) => widget.itemBuilder.call(
          context,
          LoopController.realIndex2DataIndex(
            itemCount: widget.itemCount,
            realIndex: index,
          ),
        ),
        onPageChanged: onPageChanged,
      ),
    );
  }
}

class LoopController {
  ///获取一个 [PageController]
  static LoopPageController obtainPageController({
    required int itemCount,
    int initialPage = 0,
  }) {
    return LoopPageController._(
      initialPage: itemCount > 0 ? initialPage + 1 : 0,
    );
  }

  ///数据数量转换为真实数量
  static int itemCount2RealCount(int itemCount) {
    return itemCount > 0 ? itemCount + 2 : 0;
  }

  ///真实下标转换为对应位置上的数据下标
  static int realIndex2DataIndex({
    required int itemCount,
    required int realIndex,
  }) {
    if (itemCount > 0) {
      //真实下标的第一位对应数据的最后一位
      if (realIndex == 0) {
        return itemCount - 1;
      }
      //真实数据的最后一位对应数据的第一位
      else if (realIndex == itemCount2RealCount(itemCount) - 1) {
        return 0;
      } else {
        return realIndex - 1;
      }
    } else {
      return 0;
    }
  }

  LoopController({
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.scrollDuration = const Duration(milliseconds: 1500),
    this.scrollCurve = Curves.ease,
  });

  ///是否自动滚动
  final bool autoPlay;

  ///自动滚动间隔时间
  final Duration autoPlayInterval;

  ///自动滚动时，动画持续时间
  final Duration scrollDuration;

  ///自动滚动时，滚动曲线
  final Curve scrollCurve;

  ///是否正在滚动
  final ValueNotifier<bool> _scrolling = ValueNotifier<bool>(false);

  ValueListenable<bool> get scrolling => _scrolling;

  ///用户在操作
  final ValueNotifier<bool> _userGesture = ValueNotifier<bool>(false);

  ValueListenable<bool> get userGesture => _userGesture;

  ///是否正在自动滚动
  final ValueNotifier<bool> _autoPlaying = ValueNotifier<bool>(false);

  ValueListenable<bool> get autoPlaying => _autoPlaying;

  ///页面切换变更
  final ValueNotifier<int> _onPageChanged = ValueNotifier<int>(0);

  ValueListenable<int> get onPageChanged => _onPageChanged;

  ///页面控制器
  LoopPageController? _pageController;

  ///自动滚动定时器
  Timer? _autoPlayTimer;

  ///开始自动滚动
  void startAutoPlay() {
    if (!autoPlay) return;
    if (_autoPlaying.value) return;
    _autoPlaying.value = true;
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
    _autoPlayTimer = Timer.periodic(autoPlayInterval + scrollDuration, (timer) {
      _pageController?.nextPage(
        duration: scrollDuration,
        curve: scrollCurve,
      );
    });
  }

  ///停止自动滚动
  void stopAutoPlay() {
    if (!_autoPlaying.value) return;
    _autoPlaying.value = false;
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }

  ///释放
  void dispose() {
    _scrolling.dispose();
    _userGesture.dispose();
    _autoPlaying.dispose();
    _onPageChanged.dispose();
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
  }
}

class LoopPageController extends PageController {
  LoopPageController._({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
  }) : super(
          initialPage: initialPage,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
        );
}
