import 'package:equatable/equatable.dart';

class JobLevel extends Equatable {
  final String companyId;
  final String createdAt;
  final String description;
  final String id;
  final bool isActive;
  final int levelOrder;
  final String name;
  final String updatedAt;

  const JobLevel({
    required this.companyId,
    required this.createdAt,
    required this.description,
    required this.id,
    required this.isActive,
    required this.levelOrder,
    required this.name,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        companyId,
        createdAt,
        description,
        id,
        isActive,
        levelOrder,
        name,
        updatedAt,
      ];
}
