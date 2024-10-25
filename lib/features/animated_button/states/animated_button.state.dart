import 'package:flutter/material.dart';

@immutable
sealed class AnimatedButtonState {
  final bool? isShowing;

  const AnimatedButtonState({
    this.isShowing,
  });

  AnimatedButtonState copyWith({
    bool? isShowing,
  });
}

class AnimatedButton extends AnimatedButtonState {
  const AnimatedButton({
    bool? isShowing,
  }) : super(
          isShowing: isShowing ?? false,
        );

  @override
  AnimatedButtonState copyWith({
    bool? isShowing,
  }) =>
      AnimatedButton(
        isShowing: isShowing ?? this.isShowing,
      );
}
