class DailyUsage {
  final DateTime date;
  final int totalMinutes;
  final String dayName;
  final int pickupsCount;
  final Map<String, int> appUsage;

  DailyUsage({
    required this.date,
    required this.totalMinutes,
    required this.dayName,
    this.pickupsCount = 0,
    this.appUsage = const {},
  });

  String get formattedTotalTime {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get formattedTotalTimeShort {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    
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

  double get totalHours => totalMinutes / 60.0;

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  String get relativeDateString {
    if (isToday) {
      return 'Today';
    } else if (isYesterday) {
      return 'Yesterday';
    } else {
      return dayName;
    }
  }

  DailyUsage copyWith({
    DateTime? date,
    int? totalMinutes,
    String? dayName,
    int? pickupsCount,
    Map<String, int>? appUsage,
  }) {
    return DailyUsage(
      date: date ?? this.date,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      dayName: dayName ?? this.dayName,
      pickupsCount: pickupsCount ?? this.pickupsCount,
      appUsage: appUsage ?? this.appUsage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalMinutes': totalMinutes,
      'dayName': dayName,
      'pickupsCount': pickupsCount,
      'appUsage': appUsage,
    };
  }

  factory DailyUsage.fromJson(Map<String, dynamic> json) {
    return DailyUsage(
      date: DateTime.parse(json['date']),
      totalMinutes: json['totalMinutes'] ?? 0,
      dayName: json['dayName'] ?? '',
      pickupsCount: json['pickupsCount'] ?? 0,
      appUsage: Map<String, int>.from(json['appUsage'] ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyUsage && 
           other.date.year == date.year &&
           other.date.month == date.month &&
           other.date.day == date.day;
  }

  @override
  int get hashCode => date.hashCode;

  @override
  String toString() {
    return 'DailyUsage(date: $date, totalMinutes: $totalMinutes, dayName: $dayName, pickupsCount: $pickupsCount)';
  }
}
