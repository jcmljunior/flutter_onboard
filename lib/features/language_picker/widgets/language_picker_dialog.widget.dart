import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/language_picker/constants/language_picker.constant.dart';
import 'package:flutter_onboard/features/translate/containers/translate.container.dart';

@immutable
class LanguagePickerDialogWidget extends StatefulWidget {
  const LanguagePickerDialogWidget({super.key});

  @override
  State<LanguagePickerDialogWidget> createState() =>
      _LanguagePickerDialogWidgetState();
}

class _LanguagePickerDialogWidgetState extends State<LanguagePickerDialogWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    setController();
    setScaleAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void setController() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: LanguagePickerConstant.defaultDialogAnimationDuration),
    );
  }

  void setScaleAnimation() {
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    return AnimatedBuilder(
      animation: TranslateContainer.of(context).translateManagerStoreProvider,
      builder: (BuildContext context, Widget? _) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: Center(
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    8.0,
                  ),
                ),
              ),
              title: Text(
                TranslateContainer.of(context).fetchLocalizedStrings(
                  'language_picker/dialog_title',
                ),
              ),
              content: Text(
                TranslateContainer.of(context).fetchLocalizedStrings(
                  'language_picker/dialog_content',
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _controller.reverse().then((_) {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/overview');
                    });
                  },
                  child: Text(
                    TranslateContainer.of(context).fetchLocalizedStrings(
                      'language_picker/dialog_actions/confirm',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _controller.reverse().then((_) {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text(
                    TranslateContainer.of(context).fetchLocalizedStrings(
                      'language_picker/dialog_actions/cancel',
                    ),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
