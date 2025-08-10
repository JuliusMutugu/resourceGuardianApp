import 'package:flutter/material.dart';
import '../models/app_usage.dart';
import '../models/app_limit.dart';
import '../models/daily_usage.dart';

class DigitalWellnessProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  
  // Today's overview
  String _todayScreenTime = '0h 0m';
  int _todayPickups = 0;
  String _screenTimeTrend = '';
  bool _isScreenTimeTrendPositive = false;
  String _pickupsTrend = '';
  bool _isPickupsTrendPositive = false;
  
  // App usage
  List<AppUsage> _topApps = [];
  List<AppLimit> _appLimits = [];
  List<DailyUsage> _weeklyData = [];
  
  // Digital detox
  bool _isFocusModeActive = false;
  bool _isSleepModeActive = false;
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get todayScreenTime => _todayScreenTime;
  int get todayPickups => _todayPickups;
  String get screenTimeTrend => _screenTimeTrend;
  bool get isScreenTimeTrendPositive => _isScreenTimeTrendPositive;
  String get pickupsTrend => _pickupsTrend;
  bool get isPickupsTrendPositive => _isPickupsTrendPositive;
  List<AppUsage> get topApps => _topApps;
  List<AppLimit> get appLimits => _appLimits;
  List<DailyUsage> get weeklyData => _weeklyData;
  bool get isFocusModeActive => _isFocusModeActive;
  bool get isSleepModeActive => _isSleepModeActive;
  
  Future<void> loadUsageData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Simulate API call with mock data
      await Future.delayed(const Duration(milliseconds: 500));
      
      _todayScreenTime = '3h 24m';
      _todayPickups = 47;
      _screenTimeTrend = '-15%';
      _isScreenTimeTrendPositive = false;
      _pickupsTrend = '+8%';
      _isPickupsTrendPositive = true;
      
      _topApps = _getMockAppUsage();
      _appLimits = _getMockAppLimits();
      _weeklyData = _getMockWeeklyData();
      
      // TODO: Replace with actual API calls
      // _todayScreenTime = await _apiService.getTodayScreenTime();
      // _topApps = await _apiService.getTopApps();
      
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading digital wellness data: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  void toggleFocusMode() {
    _isFocusModeActive = !_isFocusModeActive;
    notifyListeners();
    
    // TODO: Implement actual focus mode toggle
    if (_isFocusModeActive) {
      _startFocusMode();
    } else {
      _endFocusMode();
    }
  }
  
  void toggleSleepMode() {
    _isSleepModeActive = !_isSleepModeActive;
    notifyListeners();
    
    // TODO: Implement actual sleep mode toggle
    if (_isSleepModeActive) {
      _startSleepMode();
    } else {
      _endSleepMode();
    }
  }
  
  Future<void> setAppLimit(String appName, int limitMinutes) async {
    try {
      // TODO: Save to backend
      final existingIndex = _appLimits.indexWhere((limit) => limit.appName == appName);
      
      if (existingIndex >= 0) {
        _appLimits[existingIndex] = _appLimits[existingIndex].copyWith(
          limitMinutes: limitMinutes,
          isActive: true,
        );
      } else {
        _appLimits.add(AppLimit(
          appName: appName,
          limitMinutes: limitMinutes,
          isActive: true,
          appIcon: Icons.apps, // Default icon
        ));
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting app limit: $e');
    }
  }
  
  Future<void> removeAppLimit(String appName) async {
    try {
      _appLimits.removeWhere((limit) => limit.appName == appName);
      notifyListeners();
      
      // TODO: Remove from backend
    } catch (e) {
      debugPrint('Error removing app limit: $e');
    }
  }
  
  void _startFocusMode() {
    // TODO: Implement focus mode logic
    // - Block distracting apps
    // - Show focus notification
    debugPrint('Focus mode started');
  }
  
  void _endFocusMode() {
    // TODO: Implement focus mode end logic
    debugPrint('Focus mode ended');
  }
  
  void _startSleepMode() {
    // TODO: Implement sleep mode logic
    // - Silence notifications
    // - Enable do not disturb
    debugPrint('Sleep mode started');
  }
  
  void _endSleepMode() {
    // TODO: Implement sleep mode end logic
    debugPrint('Sleep mode ended');
  }
  
  List<AppUsage> _getMockAppUsage() {
    return [
      AppUsage(
        name: 'Instagram',
        usageMinutes: 95,
        limitMinutes: 60,
        sessionsCount: 12,
        icon: Icons.camera_alt,
        color: Colors.purple,
      ),
      AppUsage(
        name: 'WhatsApp',
        usageMinutes: 67,
        limitMinutes: 90,
        sessionsCount: 23,
        icon: Icons.message,
        color: Colors.green,
      ),
      AppUsage(
        name: 'YouTube',
        usageMinutes: 134,
        limitMinutes: 120,
        sessionsCount: 8,
        icon: Icons.play_arrow,
        color: Colors.red,
      ),
      AppUsage(
        name: 'TikTok',
        usageMinutes: 78,
        limitMinutes: 45,
        sessionsCount: 15,
        icon: Icons.video_library,
        color: Colors.black,
      ),
      AppUsage(
        name: 'Twitter',
        usageMinutes: 43,
        limitMinutes: 30,
        sessionsCount: 9,
        icon: Icons.alternate_email,
        color: Colors.blue,
      ),
    ];
  }
  
  List<AppLimit> _getMockAppLimits() {
    return [
      AppLimit(
        appName: 'Instagram',
        limitMinutes: 60,
        isActive: true,
        appIcon: Icons.camera_alt,
      ),
      AppLimit(
        appName: 'TikTok',
        limitMinutes: 45,
        isActive: true,
        appIcon: Icons.video_library,
      ),
      AppLimit(
        appName: 'Twitter',
        limitMinutes: 30,
        isActive: false,
        appIcon: Icons.alternate_email,
      ),
    ];
  }
  
  List<DailyUsage> _getMockWeeklyData() {
    final now = DateTime.now();
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return DailyUsage(
        date: date,
        totalMinutes: 120 + (index * 30) + (index % 2 == 0 ? 20 : -10),
        dayName: weekDays[index],
      );
    });
  }
}
