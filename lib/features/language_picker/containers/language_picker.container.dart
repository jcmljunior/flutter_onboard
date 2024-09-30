import 'package:flutter/widgets.dart';

class LanguagePickerContainer extends InheritedWidget {
  final AnimationController imageController;

  const LanguagePickerContainer({
    super.key,
    required super.child,
    required this.imageController,
  });

  @override
  bool updateShouldNotify(covariant LanguagePickerContainer oldWidget) {
    return imageController != oldWidget.imageController;
  }

  static LanguagePickerContainer of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<LanguagePickerContainer>()!;
  }
}
