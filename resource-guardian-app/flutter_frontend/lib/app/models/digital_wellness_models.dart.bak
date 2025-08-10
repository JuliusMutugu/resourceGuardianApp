class AppUsage {
  final String appName;
  final String packageName;
  final int dailyUsageMinutes;
  final int weeklyUsageMinutes;
  final String iconPath;
  final DateTime lastUsed;
  final List<int> weeklyData; // Usage minutes for each day of the week

  AppUsage({
    required this.appName,
    required this.packageName,
    required this.dailyUsageMinutes,
    required this.weeklyUsageMinutes,
    required this.iconPath,
    required this.lastUsed,
    required this.weeklyData,
  });

  String get formattedDailyUsage {
    final hours = dailyUsageMinutes ~/ 60;
    final minutes = dailyUsageMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get formattedWeeklyUsage {
    final hours = weeklyUsageMinutes ~/ 60;
    final minutes = weeklyUsageMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  factory AppUsage.fromJson(Map<String, dynamic> json) {
    return AppUsage(
      appName: json['appName'] ?? '',
      packageName: json['packageName'] ?? '',
      dailyUsageMinutes: json['dailyUsageMinutes'] ?? 0,
      weeklyUsageMinutes: json['weeklyUsageMinutes'] ?? 0,
      iconPath: json['iconPath'] ?? '',
      lastUsed: DateTime.tryParse(json['lastUsed'] ?? '') ?? DateTime.now(),
      weeklyData: List<int>.from(json['weeklyData'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'dailyUsageMinutes': dailyUsageMinutes,
      'weeklyUsageMinutes': weeklyUsageMinutes,
      'iconPath': iconPath,
      'lastUsed': lastUsed.toIso8601String(),
      'weeklyData': weeklyData,
    };
  }
}

class DailyUsage {
  final DateTime date;
  final int totalMinutes;
  final String dayName;
  final Map<String, int> appUsage; // App package name -> minutes

  DailyUsage({
    required this.date,
    required this.totalMinutes,
    required this.dayName,
    required this.appUsage,
  });

  String get formattedUsage {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  factory DailyUsage.fromJson(Map<String, dynamic> json) {
    return DailyUsage(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      totalMinutes: json['totalMinutes'] ?? 0,
      dayName: json['dayName'] ?? '',
      appUsage: Map<String, int>.from(json['appUsage'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalMinutes': totalMinutes,
      'dayName': dayName,
      'appUsage': appUsage,
    };
  }
}

class AppLimit {
  final String id;
  final String appName;
  final String packageName;
  final int dailyLimitMinutes;
  final int currentUsageMinutes;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime? lastModified;

  AppLimit({
    required this.id,
    required this.appName,
    required this.packageName,
    required this.dailyLimitMinutes,
    required this.currentUsageMinutes,
    required this.isEnabled,
    required this.createdAt,
    this.lastModified,
  });

  bool get isLimitExceeded => currentUsageMinutes >= dailyLimitMinutes;
  
  double get usagePercentage => 
      dailyLimitMinutes > 0 ? (currentUsageMinutes / dailyLimitMinutes).clamp(0.0, 1.0) : 0.0;

  int get remainingMinutes => 
      dailyLimitMinutes - currentUsageMinutes > 0 ? dailyLimitMinutes - currentUsageMinutes : 0;

  String get formattedLimit {
    final hours = dailyLimitMinutes ~/ 60;
    final minutes = dailyLimitMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get formattedUsage {
    final hours = currentUsageMinutes ~/ 60;
    final minutes = currentUsageMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get formattedRemaining {
    final hours = remainingMinutes ~/ 60;
    final minutes = remainingMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  AppLimit copyWith({
    String? id,
    String? appName,
    String? packageName,
    int? dailyLimitMinutes,
    int? currentUsageMinutes,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? lastModified,
  }) {
    return AppLimit(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      packageName: packageName ?? this.packageName,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      currentUsageMinutes: currentUsageMinutes ?? this.currentUsageMinutes,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  factory AppLimit.fromJson(Map<String, dynamic> json) {
    return AppLimit(
      id: json['id'] ?? '',
      appName: json['appName'] ?? '',
      packageName: json['packageName'] ?? '',
      dailyLimitMinutes: json['dailyLimitMinutes'] ?? 0,
      currentUsageMinutes: json['currentUsageMinutes'] ?? 0,
      isEnabled: json['isEnabled'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      lastModified: json['lastModified'] != null 
          ? DateTime.tryParse(json['lastModified']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appName': appName,
      'packageName': packageName,
      'dailyLimitMinutes': dailyLimitMinutes,
      'currentUsageMinutes': currentUsageMinutes,
      'isEnabled': isEnabled,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified?.toIso8601String(),
    };
  }
}
