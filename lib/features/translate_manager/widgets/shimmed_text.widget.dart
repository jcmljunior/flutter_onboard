import 'dart:math' show Random;

import 'package:flutter/material.dart';

import '../containers/translate_manager.container.dart';
import '../stores/translate_manager.store.dart';

@immutable
class ShimmedTextWidget extends StatefulWidget {
  final String text;
  final List<String>? replacements;
  final TextStyle? textTheme;

  const ShimmedTextWidget(
    this.text, {
    super.key,
    this.replacements,
    this.textTheme,
  });

  @override
  State<ShimmedTextWidget> createState() => _ShimmedTextWidgetState();
}

class _ShimmedTextWidgetState extends State<ShimmedTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    setController();
    setAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void setController() {
    final int randomDuration = Random().nextInt(500) + 1000;

    _controller = AnimationController(
      duration: Duration(milliseconds: randomDuration),
      vsync: this,
    )..repeat(reverse: true);
  }

  void setAnimation() {
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final TranslateManagerStore translateManagerStore =
        TranslateManagerContainer.of(context).translateManagerStore;

    return AnimatedBuilder(
      animation: Listenable.merge([
        translateManagerStore,
        _animation,
      ]),
      builder: (BuildContext context, Widget? _) {
        if (translateManagerStore.isLoading) {
          final Color startColor = Theme.of(context).colorScheme.inverseSurface;
          final Color endColor = Theme.of(context).colorScheme.onInverseSurface;

          return ShaderMask(
            shaderCallback: (Rect bounds) => LinearGradient(
              colors: [
                startColor.withOpacity(0.8),
                endColor.withOpacity(0.8),
                startColor.withOpacity(0.8),
              ],
              stops: [
                _animation.value,
                _animation.value + 0.5,
                _animation.value + 0.5,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              tileMode: TileMode.clamp,
            ).createShader(bounds),
            child: Text(
              translateManagerStore.fetchLocalizedStrings(widget.text,
                  replacements: widget.replacements),
              style: widget.textTheme,
            ),
          );
        }

        // Importante finalizar o uso do controller para bloquear o laço de execução.
        _controller.stop();

        return Text(
          translateManagerStore.fetchLocalizedStrings(widget.text,
              replacements: widget.replacements),
          style: widget.textTheme,
        );
      },
    );
  }
}
