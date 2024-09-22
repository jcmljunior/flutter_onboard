import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_onboard/features/onboard/containers/onboard.container.dart';
import 'package:flutter_onboard/features/onboard/mixins/onboard_animations.mixin.dart';
import 'package:flutter_onboard/features/onboard/providers/onboard_state.provider.dart';

@immutable
class OrganizeYourTasks extends StatefulWidget {
  const OrganizeYourTasks({super.key});

  @override
  State<OrganizeYourTasks> createState() => _OrganizeYourTasksState();
}

class _OrganizeYourTasksState extends State<OrganizeYourTasks>
    with SingleTickerProviderStateMixin, OnboardAnimations {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    setAnimationController();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void setAnimationController() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: 24.0,
          children: [
            ValueListenableBuilder<OnboardState>(
              valueListenable: OnboardContainer.of(context).onboardStore,
              builder: (BuildContext context, OnboardState state, Widget? _) {
                handleAnimationController(
                  context,
                  _controller,
                  pageIndex: state.pageIndex!,
                );

                return SizedBox(
                  width: double.infinity,
                  child: ScaleTransition(
                    scale: _controller.drive(
                      CurveTween(curve: Curves.easeInOutCubic),
                    ),
                    child: SvgPicture.asset(
                        'assets/images/intro/organize_your_tasks.svg'),
                  ),
                );
              },
            ),
            Wrap(
              runSpacing: 16.0,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Organize your tasks',
                    style: Theme.of(context).textTheme.headlineLarge!,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'You can organize your daily tasks by adding your tasks into separate categories.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
