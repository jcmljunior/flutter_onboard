import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_onboard/features/onboard/containers/onboard.container.dart';
import 'package:flutter_onboard/features/onboard/mixins/onboard_animations.mixin.dart';
import 'package:flutter_onboard/features/onboard/providers/onboard_state.provider.dart';

@immutable
class ManageYourTasks extends StatefulWidget {
  const ManageYourTasks({super.key});

  @override
  State<ManageYourTasks> createState() => _ManageYourTasksState();
}

class _ManageYourTasksState extends State<ManageYourTasks>
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
                        'assets/images/intro/manage_your_tasks.svg'),
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
                    'Manage your tasks',
                    style: Theme.of(context).textTheme.headlineLarge!,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'You can easily manage all of your daily tasks in DoMe for free.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
