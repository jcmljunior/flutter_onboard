import 'package:flutter/material.dart';

import '../stores/animated_button.store.dart';

typedef AnimatedButtons = List<Widget>;
typedef AnimatedButton = Widget;

@immutable
class AnimatedButtonWidget extends StatefulWidget {
  final AnimatedButtons buttons;

  const AnimatedButtonWidget({
    super.key,
    required this.buttons,
  });

  @override
  State<AnimatedButtonWidget> createState() => _AnimatedButtonWidgetState();
}

class _AnimatedButtonWidgetState extends State<AnimatedButtonWidget>
    with TickerProviderStateMixin {
  final AnimatedButtonStore animatedButtonStore = AnimatedButtonStore();

  late final List<AnimationController>? buttonControllers;
  late final List<Animation<double>>? buttonTweens;

  @override
  void initState() {
    super.initState();

    setButtonControllers();
    setButtonTweens();
  }

  @override
  void dispose() {
    for (final AnimationController controller in buttonControllers!) {
      controller.dispose();
    }

    super.dispose();
  }

  void setButtonControllers() {
    buttonControllers = List.generate(
      widget.buttons.length,
      (int index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void setButtonTweens() {
    buttonTweens = List.generate(
      widget.buttons.length,
      (int index) => Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: buttonControllers![index],
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }

  List<Widget> generateButtons() {
    final double spacing = 8.0;
    final AnimatedButtons buttons = [];

    for (int index = 0; index < widget.buttons.length; index++) {
      final AnimatedButton button = widget.buttons[index];

      if (index == 0) {
        buttons.add(
          FloatingActionButton(
            onPressed: () async {
              if (!animatedButtonStore.isShowing) {
                animatedButtonStore.toggleIsShowing();
              }

              for (final AnimationController controller
                  in buttonControllers!.sublist(0, widget.buttons.length)) {
                if (controller.isCompleted) {
                  controller.reverse();
                  continue;
                }

                controller.forward();

                if (index == widget.buttons.length - 1 &&
                    !animatedButtonStore.isShowing) {
                  animatedButtonStore.toggleIsShowing();
                }
              }
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: buttonTweens![index],
            ),
          ),
        );

        continue;
      }

      buttons.add(
        Visibility(
          visible: animatedButtonStore.isShowing,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.0, index.toDouble() + spacing),
              end: Offset(0.0, -.1),
            ).animate(
              CurvedAnimation(
                parent: buttonControllers![index],
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: button,
          ),
        ),
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        animatedButtonStore,
        ...buttonTweens!.sublist(0, widget.buttons.length),
      ]),
      builder: (BuildContext context, Widget? _) {
        return Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          direction: Axis.vertical,
          verticalDirection: VerticalDirection.up,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: generateButtons(),
        );
      },
    );
  }
}
