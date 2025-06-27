import 'package:equatable/equatable.dart';

class ApiKey extends Equatable {
  final String id;
  final String name;
  final String keyPrefix; // This was the incorrect field name
  final String? tenantId; // tenantId might not always be needed in the UI
  final DateTime createdAt;
  final DateTime? lastUsedAt; // lastUsedAt can be null

  const ApiKey({
    required this.id,
    required this.name,
    required this.keyPrefix,
    this.tenantId,
    required this.createdAt,
    this.lastUsedAt,
  });

  factory ApiKey.fromJson(Map<String, dynamic> json) {
    return ApiKey(
      id: json['id'].toString(), // Ensure id is always a string
      name: json['name'],
      keyPrefix: json['keyPrefix'], // Use the correct JSON key
      tenantId: json['tenantId'],
      createdAt: DateTime.parse(json['createdAt']),
      lastUsedAt: json['lastUsedAt'] != null ? DateTime.parse(json['lastUsedAt']) : null,
    );
  }

  @override
  List<Object?> get props => [id, name, keyPrefix, tenantId, createdAt, lastUsedAt];
}