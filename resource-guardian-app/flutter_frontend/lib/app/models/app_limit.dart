import 'package:flutter/material.dart';

class AppLimit {
  final String appName;
  final int limitMinutes;
  final bool isActive;
  final IconData appIcon;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppLimit({
    required this.appName,
    required this.limitMinutes,
    required this.isActive,
    required this.appIcon,
    this.createdAt,
    this.updatedAt,
  });

  String get formattedLimit {
    final hours = limitMinutes ~/ 60;
    final minutes = limitMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get formattedLimitShort {
    final hours = limitMinutes ~/ 60;
    final minutes = limitMinutes % 60;
    
    if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      } else {
        return '${hours}h';
      }
    } else {
      return '${minutes}m';
    }
  }

  AppLimit copyWith({
    String? appName,
    int? limitMinutes,
    bool? isActive,
    IconData? appIcon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppLimit(
      appName: appName ?? this.appName,
      limitMinutes: limitMinutes ?? this.limitMinutes,
      isActive: isActive ?? this.isActive,
      appIcon: appIcon ?? this.appIcon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'limitMinutes': limitMinutes,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory AppLimit.fromJson(Map<String, dynamic> json) {
    return AppLimit(
      appName: json['appName'] ?? '',
      limitMinutes: json['limitMinutes'] ?? 0,
      isActive: json['isActive'] ?? false,
      appIcon: Icons.apps, // Default icon, should be mapped from app name
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppLimit && other.appName == appName;
  }

  @override
  int get hashCode => appName.hashCode;

  @override
  String toString() {
    return 'AppLimit(appName: $appName, limitMinutes: $limitMinutes, isActive: $isActive)';
  }
}
