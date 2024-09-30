import 'package:flutter/material.dart' show BuildContext, ValueNotifier;
import 'package:flutter_onboard/features/overview/constants/overview.constant.dart';
import 'package:flutter_onboard/features/overview/providers/overview_state.provider.dart';
import 'package:flutter_onboard/features/translate/containers/translate.container.dart';

class OverviewStore extends ValueNotifier<OverViewStateProvider> {
  OverviewStore() : super(const OverviewState());

  String getTitleByIndex(BuildContext context, int index) {
    return TranslateContainer.of(context).fetchLocalizedStrings(
      value.overviewItems!.elementAt(index).title!,
    );
  }

  String getDescriptionByIndex(BuildContext context, int index) {
    return TranslateContainer.of(context).fetchLocalizedStrings(
      value.overviewItems!.elementAt(index).description!,
    );
  }

  String getImageByIndex(int index) {
    return '${OverviewConstant.pathForAssets}${value.overviewItems!.elementAt(index).image!}';
  }

  void onPageChanged(int index) {
    value = value.copyWith(
      currentIndex: index,
    );
  }
}
