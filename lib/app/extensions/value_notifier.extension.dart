import 'package:flutter/foundation.dart';

extension ValueNotifierExtension<T> on ValueNotifier<T> {
  set state(T state) => value = state;

  T get state => value;
}
