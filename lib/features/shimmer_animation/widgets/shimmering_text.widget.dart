import 'dart:math' show Random;

import 'package:flutter/material.dart' show Theme;
import 'package:flutter/widgets.dart';

import '../../translate_manager/containers/translate_manager.container.dart';

@immutable
class ShimmeringTextWidget<T> extends StatefulWidget {
  final String text;
  final List<String>? replacements;
  final TextStyle? textTheme;
  final ValueNotifier<T> store;

  const ShimmeringTextWidget(
    this.text, {
    super.key,
    this.replacements,
    this.textTheme,
    required this.store,
  });

  @override
  State<ShimmeringTextWidget> createState() => _ShimmeringTextWidgetState();
}

class _ShimmeringTextWidgetState extends State<ShimmeringTextWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _setController();
    _setAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _setController() {
    final int randomDuration = _random.nextInt(500) + 1000;

    _controller = AnimationController(
      duration: Duration(milliseconds: randomDuration),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _setAnimation() {
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  Shader _getShader(Rect bounds, Color startColor, Color endColor) {
    return LinearGradient(
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
    ).createShader(bounds);
  }

  Widget _buildShimmeringText() {
    final Color startColor = Theme.of(context).colorScheme.inverseSurface;
    final Color endColor = Theme.of(context).colorScheme.onInverseSurface;

    return ShaderMask(
      shaderCallback: (bounds) => _getShader(bounds, startColor, endColor),
      child: _buildLocalizedText(),
    );
  }

  Widget _buildLocalizedText() {
    final translateManagerStore =
        TranslateManagerContainer.of(context).translateManagerStore;

    return Text(
      translateManagerStore.fetchLocalizedStrings(widget.text,
          replacements: widget.replacements),
      style: widget.textTheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.store,
        _animation,
      ]),
      builder: (BuildContext context, Widget? _) {
        final bool isLoading = widget.store.value.isLoading ?? false;

        if (isLoading) {
          return _buildShimmeringText();
        }

        if (_controller.isAnimating) {
          _controller.stop();
        }

        return _buildLocalizedText();
      },
    );
  }
}
