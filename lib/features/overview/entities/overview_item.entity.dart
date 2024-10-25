import 'package:flutter/material.dart' show immutable;

@immutable
abstract class OverviewItemEntity {
  final int id;
  final String title;
  final String description;
  final String imagePath;

  const OverviewItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
