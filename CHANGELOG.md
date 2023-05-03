## 0.1.2

* Add [`Refreshable<T>`](./lib/src/data/refreshable/refreshable.dart)
  subclass [`AbsSimpleRefreshableController<T>`](
  ./lib/src/data/refreshable/simple/simple_refreshable_controller.dart)
* Add [`Pagination<T>`](./lib/src/data/pagination/pagination.dart)
  subclass [`AbsSimplePaginationController<T, N>`](
  ./lib/src/data/pagination/simple/simple_pagination_controller.dart)
* Both simple controller is data wrapper needless.

## 0.1.1

* Add `updatedCount` field
  for [`CacheableValueListenable`](./lib/src/data/value_notifier/cacheable_value_listenable.dart)
* Default value of [`VisibilityValueNotifier`](./lib/src/widgets/visibility_detector_widget.dart)
  comes from value of current `AppLifecycleState`

## 0.1.0

* Rename `april` to `april_flutter_utils`
* Rename `AprilMethod.dart`
  to [`AprilAndroidMethod.dart`](./lib/src/method/april_android_method.dart)
* Add [CachedValueNotifier<T>](./lib/src/data/value_notifier/cacheable_value_listenable.dart) who
  can cache all values.
* Optimize all codes
  of file [`value_listenable_builder.dart`](./lib/src/widgets/value_listenable_builder.dart)

## 0.0.4

* optimize the code of [refreshable.dart](./lib/src/data/refreshable/refreshable.dart)
  、[refreshable_controller.dart](./lib/src/data/refreshable/refreshable_controller.dart)
  、[pagination.dart](./lib/src/data/pagination/pagination.dart)
  、[pagination_controller.dart](./lib/src/data/pagination/pagination_controller.dart)
* remove deprecated code

## 0.0.3

* remove file `page_visibility.dart`、`notifier_mixin.dart`
* rename `SelectValueNotifierX` to `TransformableValueNotifierX`
* rename `SelectorListenableBuilderX` to `TransformableListenableBuilderX`
* rename `widget_visibility.dart` to `visibility_detector_widget.dart` and change the code, now you
  can listen the visibility value from `VisibilityValueNotifier`.

## 0.0.2

* import more files.

## 0.0.1

* init
