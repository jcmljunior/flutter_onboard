import 'package:flutter/foundation.dart';
import 'package:flutter_onboard/features/onboard/providers/onboard_state.provider.dart';

class OnboardStore extends ValueNotifier<OnboardState> {
  OnboardStore()
      : super(
          const OnboardStateInitial(
            pageIndex: 0,
          ),
        );

  void handlePageChanged(int index) {
    value = value.copyWith(
      pageIndex: index,
    );
  }
}
