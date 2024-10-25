import 'package:flutter/material.dart';

import '../../../core/dialog/stores/dialog.store.dart';
import '../../../core/dialog/widgets/dialog.widget.dart';
import '../../translate_manager/constants/translate_manager.constant.dart';
import '../../translate_manager/containers/translate_manager.container.dart';
import '../../translate_manager/stores/translate_manager.store.dart';
import '../constants/choose_language.constant.dart';
import '../containers/choose_language.container.dart';

@immutable
class FloatActionButtonWidget extends StatefulWidget {
  const FloatActionButtonWidget({super.key});

  @override
  State<FloatActionButtonWidget> createState() =>
      _FloatActionButtonWidgetState();
}

class _FloatActionButtonWidgetState extends State<FloatActionButtonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController fabController;
  late final Animation<Offset> fabAnimation;

  static const _animationDuration = Duration(
      milliseconds: ChooseLanguageConstant.defaultFabAnimationDuration);
  static const _animationCurve = Curves.fastOutSlowIn;

  @override
  void initState() {
    super.initState();

    setFabController();
    setFabAnimation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fabAnimationHandler();
    });
  }

  @override
  void dispose() {
    fabController.dispose();

    super.dispose();
  }

  void setFabController() {
    fabController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
  }

  void setFabAnimation() {
    fabAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: fabController,
        curve: _animationCurve,
      ),
    );
  }

  Future<void> fabAnimationHandler({bool reverse = false}) async {
    if (reverse) {
      await fabController.reverse();
      return;
    }

    fabController.forward();
  }

  void _navigateToOverview(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/overview');
    }
  }

  @override
  Widget build(BuildContext context) {
    final DialogStore dialogStore =
        ChooseLanguageContainer.of(context).dialogStore;
    final TranslateManagerStore translateManagerStore =
        TranslateManagerContainer.of(context).translateManagerStore;

    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: ChooseLanguageConstant.defaultFabAnimationDuration,
      ),
      switchInCurve: Curves.linear,
      switchOutCurve: Curves.fastOutSlowIn,
      child: SlideTransition(
        key: ValueKey<bool>(fabController.isCompleted),
        position: fabAnimation,
        child: FloatingActionButton(
          onPressed: () async {
            // Bloqueia a exibição do dialogo se o pacote de idioma estiver completo.
            if (translateManagerStore
                .isFullyTranslated[translateManagerStore.currentLocale]!) {
              // Lida com a animação do botão flutuante.
              await fabAnimationHandler(reverse: true);

              // Limpa os pacotes de idioma não utilizados.
              translateManagerStore.cleanUnusedLocalizedStringsHandler();

              // Navegação para tela de apresentação.
              // ignore: use_build_context_synchronously
              _navigateToOverview(context);

              return;
            }

            await DialogWidget.show(
              context,
              title: Text(translateManagerStore.fetchLocalizedStrings(
                  'choose_language.incomplete_language.title')),
              content: Text(
                translateManagerStore.fetchLocalizedStrings(
                  'choose_language.incomplete_language.description',
                  replacements: [
                    translateManagerStore.fetchLocalizedStrings(
                        'choose_language.${translateManagerStore.currentLocale}'),
                    translateManagerStore.fetchLocalizedStrings(
                        'choose_language.${TranslateManagerConstant.defaultLocale}'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(translateManagerStore.fetchLocalizedStrings(
                      'choose_language.incomplete_language.confirm')),
                  onPressed: () => Navigator.of(context).pop('confirm'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(translateManagerStore.fetchLocalizedStrings(
                      'choose_language.incomplete_language.cancel')),
                  onPressed: () => Navigator.of(context).pop('cancel'),
                ),
              ],
              onOpen: () {
                // Inicialização do dialogo.
                dialogStore.toggleIsShowing();
              },
              onClose: (dynamic response) async {
                if (response == 'confirm') {
                  // Lida com a animação do botão flutuante.
                  await fabAnimationHandler(reverse: true);

                  // Limpa os pacotes de idioma não utilizados.
                  translateManagerStore.cleanUnusedLocalizedStringsHandler();

                  // Navega para a tela de apresentação.
                  // ignore: use_build_context_synchronously
                  _navigateToOverview(context);
                }

                // Altera o estado do dialogo para o feedback de finalização do processo.
                dialogStore.toggleIsShowing();
              },
            );
          },
          child: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
