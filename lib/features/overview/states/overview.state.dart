import 'package:flutter/material.dart' show immutable;

import '../models/overview_item.model.dart';

@immutable
sealed class OverviewState {
  final int? index;
  final bool? isScrolling;
  final List<OverviewItemModel>? overviewItems;

  const OverviewState({
    this.index,
    this.isScrolling,
    this.overviewItems,
  }) : assert(index != null && isScrolling != null && overviewItems != null);

  OverviewState copyWith({
    int? index,
    bool? isScrolling,
    List<OverviewItemModel>? overviewItems,
  });
}

class Overview extends OverviewState {
  const Overview(
      {int? index, bool? isScrolling, List<OverviewItemModel>? overviewItems})
      : super(
          index: index ?? 0,
          isScrolling: isScrolling ?? false,
          overviewItems: overviewItems ??
              const [
                OverviewItemModel(
                  id: 0,
                  title: 'overview.manage_your_tasks.title',
                  description: 'overview.manage_your_tasks.description',
                  imagePath: 'resources/images/undraw_file_manager.svg',
                ),
                OverviewItemModel(
                  id: 1,
                  title: 'overview.schedule_your_tasks.title',
                  description: 'overview.schedule_your_tasks.description',
                  imagePath: 'resources/images/undraw_time_management.svg',
                ),
                OverviewItemModel(
                  id: 2,
                  title: 'overview.plan_your_tasks.title',
                  description: 'overview.plan_your_tasks.description',
                  imagePath: 'resources/images/undraw_schedule.svg',
                ),
                OverviewItemModel(
                  id: 3,
                  title: 'overview.get_started.title',
                  description: 'overview.get_started.description',
                  imagePath: 'resources/images/get_started.svg',
                ),
              ],
        );

  @override
  OverviewState copyWith({
    int? index,
    bool? isScrolling,
    List<OverviewItemModel>? overviewItems,
  }) =>
      Overview(
        index: index ?? this.index,
        isScrolling: isScrolling ?? this.isScrolling,
        overviewItems: overviewItems ?? this.overviewItems,
      );
}
