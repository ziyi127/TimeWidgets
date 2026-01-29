import 'dart:convert';

class PluginManifest {
  final String id;
  final String name;
  final String version;
  final String description;
  final String author;
  final String minAppVersion;
  final String entryPoint;
  final List<String> permissions;
  final Map<String, dynamic> extra;

  PluginManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.description,
    required this.author,
    required this.minAppVersion,
    required this.entryPoint,
    this.permissions = const [],
    this.extra = const {},
  });

  factory PluginManifest.fromJson(Map<String, dynamic> json) {
    return PluginManifest(
      id: json['id'] as String,
      name: json['name'] as String,
      version: json['version'] as String,
      description: json['description'] as String? ?? '',
      author: json['author'] as String? ?? 'Unknown',
      minAppVersion: json['minAppVersion'] as String? ?? '1.0.0',
      entryPoint: json['entryPoint'] as String? ?? 'main.js',
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      extra: json['extra'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'description': description,
      'author': author,
      'minAppVersion': minAppVersion,
      'entryPoint': entryPoint,
      'permissions': permissions,
      'extra': extra,
    };
  }

  static PluginManifest parse(String jsonString) {
    return PluginManifest.fromJson(json.decode(jsonString) as Map<String, dynamic>);
  }
}
