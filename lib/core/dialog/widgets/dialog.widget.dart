import 'package:flutter/material.dart';

class DialogWidget {
  static Future<void> show(
    BuildContext context, {
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    Function()? onOpen,
    Function(dynamic response)? onClose,
  }) async {
    final dynamic dialog = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext _) {
        if (onOpen != null) {
          onOpen();
        }

        return DialogContent(
          title: title,
          content: content,
          actions: actions,
        );
      },
    );

    if (onClose != null && dialog != null) {
      onClose(dialog);
    }
  }
}

@immutable
class DialogContent extends StatefulWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  const DialogContent({
    super.key,
    this.title,
    this.content,
    this.actions,
  });

  @override
  State<DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

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
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: AlertDialog(
        title: widget.title,
        content: widget.content,
        actions: widget.actions,
      ),
    );
  }
}
