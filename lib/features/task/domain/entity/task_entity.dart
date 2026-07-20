import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  const TaskEntity({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorValue,
    required this.createdAt,
    this.updatedAt,
    this.isArchived = false,
  });

  final String id;
  final String name;
  final String iconName;
  final int colorValue;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isArchived;

  TaskEntity copyWith({
    String? id,
    String? name,
    String? iconName,
    int? colorValue,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    iconName,
    colorValue,
    createdAt,
    updatedAt,
    isArchived,
  ];
}
