import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/main/dashboard_screen.dart';
import '../screens/main/transactions_screen.dart';
import '../screens/main/goals_screen.dart';
import '../screens/main/profile_screen.dart';
import '../screens/main/settings_screen.dart';
import '../screens/main/analytics_screen.dart';
import '../screens/main/notifications_screen.dart';
import '../screens/main/personal_info_screen.dart';
import '../screens/main/security_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/';
  static const String dashboard = '/dashboard';
  static const String transactions = '/transactions';
  static const String goals = '/goals';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String analytics = '/analytics';
  static const String notifications = '/notifications';
  static const String personalInfo = '/personal-info';
  static const String security = '/security';

  static final GoRouter router = GoRouter(
    initialLocation: login, // Start with login for now
    routes: [
      // Auth routes
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main app with shell route for bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/transactions',
            name: 'transactions',
            builder: (context, state) => const TransactionsScreen(),
          ),
          GoRoute(
            path: '/goals',
            name: 'goals',
            builder: (context, state) => const GoalsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Additional full-screen routes
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/personal-info',
        name: 'personal-info',
        builder: (context, state) => const PersonalInfoScreen(),
      ),
      GoRoute(
        path: '/security',
        name: 'security',
        builder: (context, state) => const SecurityScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.toString()}'),
      ),
    ),
  );
}
