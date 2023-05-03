## 0.1.2+1

* Fix "private field xxx could be 'final'" warning.

## 0.1.2

* Add subclass [`AbsSimpleRefreshableController<T>`](
  ./lib/src/data/refreshable/simple/simple_refreshable_controller.dart)
  of [`Refreshable<T>`](./lib/src/data/refreshable/refreshable.dart)
* Add subclass [`AbsSimplePaginationController<T, N>`](
  ./lib/src/data/pagination/simple/simple_pagination_controller.dart)
  of [`Pagination<T>`](./lib/src/data/pagination/pagination.dart)
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
* Add [`CachedValueNotifier<T>`](./lib/src/data/value_notifier/cacheable_value_listenable.dart) who
  can cache all values.
* Optimize all codes
  of file [`value_listenable_builder.dart`](./lib/src/widgets/value_listenable_builder.dart)

## 0.0.4

* optimize the code of [`refreshable.dart`](./lib/src/data/refreshable/refreshable.dart)
  、[`refreshable_controller.dart`](./lib/src/data/refreshable/refreshable_controller.dart)
  、[`pagination.dart`](./lib/src/data/pagination/pagination.dart)
  、[`pagination_controller.dart`](./lib/src/data/pagination/pagination_controller.dart)
* remove deprecated code

## 0.0.3

* remove file `page_visibility.dart`、`notifier_mixin.dart`
* rename file `SelectValueNotifierX`
  to [`TransformableValueNotifierX`](./lib/src/data/value_notifier/transformable_value_notifier.dart)
* rename file `SelectorListenableBuilderX`
  to [`TransformableListenableBuilderX`](./lib/src/widgets/transformable_listenable_builder.dart)
* rename file `widget_visibility.dart`
  to [`visibility_detector_widget.dart`](./lib/src/widgets/visibility_detector_widget.dart) and
  change the code, now you
  can listen the visibility value
  from class [`VisibilityValueNotifier`](./lib/src/widgets/visibility_detector_widget.dart).

## 0.0.2

* import more files.

## 0.0.1

* init
