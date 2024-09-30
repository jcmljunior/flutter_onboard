import 'package:flutter/foundation.dart';
import 'package:flutter_onboard/features/overview/models/overview_item.model.dart';

@immutable
sealed class OverViewStateProvider {
  final int? currentIndex;
  final List<OverviewItemModel>? overviewItems;

  const OverViewStateProvider({
    this.overviewItems,
    this.currentIndex,
  });

  OverViewStateProvider copyWith({
    List<OverviewItemModel>? overviewItems,
    int? currentIndex,
  });
}

class OverviewState extends OverViewStateProvider {
  const OverviewState({
    List<OverviewItemModel>? overviewItems,
    int? currentIndex,
  }) : super(
          overviewItems: overviewItems ??
              const [
                OverviewItemModel(
                  title: 'overview/manage_your_tasks/title',
                  description: 'overview/manage_your_tasks/description',
                  image: 'manage_your_tasks.svg',
                ),
                OverviewItemModel(
                  title: 'overview/organize_your_tasks/title',
                  description: 'overview/organize_your_tasks/description',
                  image: 'organize_your_tasks.svg',
                ),
                OverviewItemModel(
                  title: 'overview/create_daily_routine/title',
                  description: 'overview/create_daily_routine/description',
                  image: 'create_daily_routine.svg',
                ),
                OverviewItemModel(
                  title: 'overview/personalize_your_color/title',
                  description: 'overview/personalize_your_color/description',
                  image: 'personalize_your_color.svg',
                ),
                OverviewItemModel(
                  title: 'overview/get_started/title',
                  description: 'overview/get_started/description',
                  image: 'get_started.svg',
                ),
              ],
          currentIndex: currentIndex ?? 0,
        );

  @override
  OverViewStateProvider copyWith({
    List<OverviewItemModel>? overviewItems,
    int? currentIndex,
  }) {
    return OverviewState(
      overviewItems: overviewItems ?? this.overviewItems,
      currentIndex: currentIndex,
    );
  }
}
