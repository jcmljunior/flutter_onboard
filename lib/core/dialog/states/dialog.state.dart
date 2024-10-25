import 'package:flutter/material.dart' show immutable;

@immutable
sealed class DialogState {
  final bool? isShowing;

  const DialogState({
    this.isShowing,
  }) : assert(isShowing != null);

  DialogState copyWith({
    bool? isShowing,
  });
}

class DialogWidget extends DialogState {
  const DialogWidget({
    bool? isShowing,
  }) : super(isShowing: isShowing ?? false);

  @override
  DialogState copyWith({bool? isShowing}) => DialogWidget(
        isShowing: isShowing ?? this.isShowing,
      );
}
