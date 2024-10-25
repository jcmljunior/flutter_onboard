import 'package:flutter/foundation.dart';

import '../../../app/extensions/value_notifier.extension.dart';
import '../models/overview_item.model.dart';
import '../states/overview.state.dart';

class OverviewStore extends ValueNotifier<OverviewState> {
  OverviewStore() : super(const Overview());

  set isScrolling(bool value) {
    if (state.isScrolling == value) return;

    state = state.copyWith(
      isScrolling: value,
    );
  }

  bool get isScrolling => state.isScrolling!;

  set index(int value) {
    if (state.index == value) return;

    state = state.copyWith(
      index: value,
    );
  }

  int get index => state.index!;

  set overviewItems(List<OverviewItemModel> value) {
    if (state.overviewItems == value) return;

    state = state.copyWith(
      overviewItems: value,
    );
  }

  List<OverviewItemModel> get overviewItems => state.overviewItems!;
}
