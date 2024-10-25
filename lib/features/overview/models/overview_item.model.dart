import '../entities/overview_item.entity.dart';

class OverviewItemModel extends OverviewItemEntity {
  const OverviewItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imagePath,
  });

  factory OverviewItemModel.fromJson(Map<String, dynamic> json) =>
      OverviewItemModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imagePath: json['imagePath'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'imagePath': imagePath,
      };

  OverviewItemModel copyWith({
    int? id,
    String? title,
    String? description,
    String? imagePath,
  }) {
    return OverviewItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
