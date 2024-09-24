import 'package:flutter/material.dart';
import 'package:flutter_onboard/features/welcome/containers/translate_manager.container.dart';
import 'package:flutter_onboard/features/welcome/providers/translate_manager_state.provider.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslateManager(
      child: Builder(builder: (BuildContext context) {
        return ValueListenableBuilder<TranslateManagerState>(
            valueListenable: TranslateManager.of(context).store,
            builder:
                (BuildContext context, TranslateManagerState state, Widget? _) {
              return Scaffold(
                appBar: AppBar(),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TranslateManager.of(context).translate(
                        'welcome/title',
                        args: ['Flutter Onboard'],
                      ),
                    ),
                    Text(
                      TranslateManager.of(context).translate(
                        'welcome/subtitle',
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Text(
                      TranslateManager.of(context).translate(
                        'welcome/language',
                      ),
                    ),
                  ],
                ),
              );
            });
      }),
    );
  }
}
