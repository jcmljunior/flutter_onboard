import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/translate_manager/containers/translate_manager.container.dart';

class DialogContainer {
  static Future<void> show(
    BuildContext context, {
    String? title,
    String? content,
    String? cancelText,
    String? confirmText,
    Function()? onConfirm,
    Function()? onCancel,
    Function()? onClosed,
  }) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogContent(
          title: title,
          content: content,
          cancelText: cancelText,
          confirmText: confirmText,
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      },
    ).then((_) {
      if (onClosed != null) {
        onClosed();
      }
    });
  }
}

class DialogContent extends StatefulWidget {
  final String? title;
  final String? content;
  final String? cancelText;
  final String? confirmText;
  final Function()? onConfirm;
  final Function()? onCancel;

  const DialogContent({
    super.key,
    this.title,
    this.content,
    this.cancelText,
    this.confirmText,
    this.onConfirm,
    this.onCancel,
  }) : assert(title != null ||
            content != null &&
                onConfirm != null &&
                confirmText != null &&
                onCancel != null &&
                cancelText != null);

  @override
  State<DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  void _setAnimation() {
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  Animation<double> get animation => _animation;

  void _setController() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  AnimationController get controller => _controller;

  @override
  void initState() {
    super.initState();

    _setController();
    _setAnimation();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              8.0,
            ),
          ),
        ),
        title: widget.title == null
            ? null
            : TranslateManagerContainer.of(context)
                .translateManagerStore
                .localizedTextWidget(widget.title!),
        content: widget.content == null
            ? null
            : TranslateManagerContainer.of(context)
                .translateManagerStore
                .localizedTextWidget(widget.content!),
        actions: [
          if (widget.confirmText != null)
            TextButton(
              onPressed: widget.onConfirm,
              child: TranslateManagerContainer.of(context)
                  .translateManagerStore
                  .localizedTextWidget(widget.confirmText!),
            ),
          if (widget.cancelText != null)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: widget.onCancel,
              child: TranslateManagerContainer.of(context)
                  .translateManagerStore
                  .localizedTextWidget(widget.cancelText!),
            ),
        ],
      ),
    );
  }
}

@Deprecated('Use DialogContainer() em vez disso.')
class DialogWidget extends StatelessWidget {
  const DialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
