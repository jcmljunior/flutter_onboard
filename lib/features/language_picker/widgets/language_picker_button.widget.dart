import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/language_picker/constants/language_picker.constant.dart';
import 'package:flutter_onboard/features/language_picker/containers/language_picker.container.dart';
import 'package:flutter_onboard/features/language_picker/widgets/language_picker_dialog.widget.dart';
import 'package:flutter_onboard/features/translate/containers/translate.container.dart';

class LanguagePickerButtonWidget extends StatefulWidget {
  const LanguagePickerButtonWidget({super.key});

  @override
  State<LanguagePickerButtonWidget> createState() =>
      _LanguagePickerButtonWidgetState();
}

class _LanguagePickerButtonWidgetState extends State<LanguagePickerButtonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabController;
  late final Animation<Offset> fabAnimation;

  @override
  void initState() {
    super.initState();

    setFabController();
    setFabAnimation();
  }

  @override
  void dispose() {
    fabController.dispose();

    super.dispose();
  }

  void setFabController() {
    fabController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: LanguagePickerConstant.defaultFabAnimationDuration),
    );
  }

  void setFabAnimation() {
    fabAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: fabController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  void fabAnimationHandler({bool? reverse = false}) {
    if (reverse == true) {
      fabController.reverse();
      return;
    }

    fabController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LanguagePickerContainer.of(context).imageController,
      builder: (BuildContext context, Widget? _) {
        if (LanguagePickerContainer.of(context).imageController.isCompleted) {
          fabAnimationHandler();
        }

        return AnimatedSwitcher(
          duration: const Duration(
              milliseconds:
                  LanguagePickerConstant.defaultFabAnimationDuration ~/ 20),
          switchInCurve: Curves.linear,
          switchOutCurve: Curves.fastOutSlowIn,
          child: SlideTransition(
            position: fabAnimation,
            child: FloatingActionButton(
              elevation: 1.0,
              shape: const CircleBorder(),
              onPressed: () {
                if (!TranslateContainer.of(context)
                    .translateManagerStoreProvider
                    .value
                    .hasCompletedTranslation!) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const LanguagePickerDialogWidget();
                    },
                  );

                  return;
                }

                Navigator.pushReplacementNamed(context, '/overview');
              },
              child: const Icon(
                Icons.arrow_forward,
              ),
            ),
          ),
        );
      },
    );
  }
}
