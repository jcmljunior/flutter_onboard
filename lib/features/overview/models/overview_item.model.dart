import 'package:flutter_onboard/features/overview/entities/overview_item.entity.dart';

class OverviewItemModel extends OverviewItemEntity {
  const OverviewItemModel({
    super.title,
    super.description,
    super.image,
  });

  factory OverviewItemModel.fromEntity(OverviewItemEntity entity) {
    return OverviewItemModel(
      title: entity.title,
      description: entity.description,
      image: entity.image,
    );
  }

  OverviewItemModel copyWith({
    String? title,
    String? description,
    String? image,
  }) {
    return OverviewItemModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }
}
