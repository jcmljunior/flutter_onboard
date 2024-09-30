import 'package:flutter/material.dart' show immutable;

@immutable
abstract class OverviewItemEntity {
  final String? title;
  final String? description;
  final String? image;

  const OverviewItemEntity({
    this.title,
    this.description,
    this.image,
  });
}
