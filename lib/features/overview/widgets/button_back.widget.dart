import 'package:flutter/material.dart';

import '../../translate_manager/containers/translate_manager.container.dart';

class ButtonBackWidget extends StatelessWidget {
  const ButtonBackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final translateManagerStore =
        TranslateManagerContainer.of(context).translateManagerStore;

    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chevron_left),
          Text(translateManagerStore.fetchLocalizedStrings('overview.back')),
        ],
      ),
    );
  }
}
