import 'package:equatable/equatable.dart';

class ApiKey extends Equatable {
  final String id;
  final String name;
  final String key;
  final String tenantId;
  final DateTime createdAt;

  const ApiKey({
    required this.id,
    required this.name,
    required this.key,
    required this.tenantId,
    required this.createdAt,
  });

  factory ApiKey.fromJson(Map<String, dynamic> json) {
    return ApiKey(
      id: json['id'],
      name: json['name'],
      key: json['key'],
      tenantId: json['tenantId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  List<Object?> get props => [id, name, key, tenantId, createdAt];
}