import 'package:flutter/material.dart' show immutable;

@immutable
sealed class AppState {
  final bool? isInitialized;

  const AppState({
    this.isInitialized,
  }) : assert(isInitialized != null);

  AppState copyWith({
    bool? isInitialized,
  });
}

class App extends AppState {
  const App({
    bool? isInitialized,
  }) : super(isInitialized: isInitialized ?? false);

  @override
  AppState copyWith({bool? isInitialized}) {
    return App(
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}
