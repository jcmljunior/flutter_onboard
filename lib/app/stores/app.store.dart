import 'package:flutter/material.dart' show WidgetsBinding, ValueNotifier;

import '../states/app.state.dart';

class AppStore extends ValueNotifier<AppState> {
  AppStore() : super(const App()) {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        WidgetsBinding.instance.endOfFrame.then((_) => isInitialized = true));
  }

  set state(AppState state) {
    if (super.value == state) return;

    super.value = state;
  }

  AppState get state => super.value;

  set isInitialized(bool isInitialized) {
    if (state.isInitialized == isInitialized) return;

    state = state.copyWith(
      isInitialized: isInitialized,
    );
  }

  bool get isInitialized => state.isInitialized!;
}
