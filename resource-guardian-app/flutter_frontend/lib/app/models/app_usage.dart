import 'package:flutter/material.dart';

class AppUsage {
  final String name;
  final int usageMinutes;
  final int limitMinutes;
  final int sessionsCount;
  final IconData icon;
  final Color color;

  AppUsage({
    required this.name,
    required this.usageMinutes,
    this.limitMinutes = 0,
    required this.sessionsCount,
    required this.icon,
    required this.color,
  });

  String get formattedUsageTime {
    final hours = usageMinutes ~/ 60;
    final minutes = usageMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get formattedLimitTime {
    if (limitMinutes == 0) return 'No limit';
    
    final hours = limitMinutes ~/ 60;
    final minutes = limitMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  bool get isOverLimit => limitMinutes > 0 && usageMinutes > limitMinutes;

  double get limitProgress => limitMinutes > 0 ? usageMinutes / limitMinutes : 0.0;

  AppUsage copyWith({
    String? name,
    int? usageMinutes,
    int? limitMinutes,
    int? sessionsCount,
    IconData? icon,
    Color? color,
  }) {
    return AppUsage(
      name: name ?? this.name,
      usageMinutes: usageMinutes ?? this.usageMinutes,
      limitMinutes: limitMinutes ?? this.limitMinutes,
      sessionsCount: sessionsCount ?? this.sessionsCount,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'usageMinutes': usageMinutes,
      'limitMinutes': limitMinutes,
      'sessionsCount': sessionsCount,
    };
  }

  factory AppUsage.fromJson(Map<String, dynamic> json) {
    return AppUsage(
      name: json['name'] ?? '',
      usageMinutes: json['usageMinutes'] ?? 0,
      limitMinutes: json['limitMinutes'] ?? 0,
      sessionsCount: json['sessionsCount'] ?? 0,
      icon: Icons.apps, // Default icon, should be mapped from app name
      color: Colors.blue, // Default color, should be mapped from app name
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUsage && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'AppUsage(name: $name, usageMinutes: $usageMinutes, limitMinutes: $limitMinutes, sessionsCount: $sessionsCount)';
  }
}
