import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/theme/app_theme.dart';
import 'app/providers/theme_provider.dart';
import 'app/providers/auth_provider.dart';
import 'app/providers/dashboard_provider.dart';
import 'app/providers/goals_provider.dart';
import 'app/providers/digital_wellness_provider.dart';
import 'app/providers/transaction_provider.dart';
import 'app/screens/main/dashboard_screen.dart';
import 'app/screens/main/transactions_screen.dart';
import 'app/screens/main/goals_screen.dart';
import 'app/screens/main/profile_screen.dart';
import 'app/screens/main/digital_wellness_screen.dart';
import 'app/screens/main/settings_screen.dart';
import 'app/screens/main/analytics_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ResourceGuardianApp());
}

class ResourceGuardianApp extends StatelessWidget {
  const ResourceGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => GoalsProvider()),
        ChangeNotifierProvider(create: (_) => DigitalWellnessProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Resource Guardian',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const MainAppScreen(),
          );
        },
      ),
    );
  }
}

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionsScreen(),
    const GoalsScreen(),
    const DigitalWellnessScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Transactions',
    'Goals',
    'Digital Wellness',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => themeProvider.toggleTheme(),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      themeProvider.isDarkMode 
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                      key: ValueKey(themeProvider.isDarkMode),
                    ),
                  ),
                  tooltip: 'Toggle theme',
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Implement notifications
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Notifications coming soon!'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_rounded),
              tooltip: 'Notifications',
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E293B)
                : Colors.white,
            selectedItemColor: const Color(0xFF6366F1),
            unselectedItemColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white60
                : Colors.black54,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                activeIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_rounded),
                activeIcon: Icon(Icons.account_balance_wallet),
                label: 'Transactions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.savings_rounded),
                activeIcon: Icon(Icons.savings),
                label: 'Goals',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.health_and_safety_rounded),
                activeIcon: Icon(Icons.health_and_safety),
                label: 'Wellness',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E293B)
          : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Resource Guardian',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Smart Financial Management',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildModernDrawerItem(
            icon: Icons.dashboard_rounded,
            title: 'Dashboard',
            index: 0,
          ),
          _buildModernDrawerItem(
            icon: Icons.account_balance_wallet_rounded,
            title: 'Transactions',
            index: 1,
          ),
          _buildModernDrawerItem(
            icon: Icons.savings_rounded,
            title: 'Savings Goals',
            index: 2,
          ),
          _buildModernDrawerItem(
            icon: Icons.health_and_safety_rounded,
            title: 'Digital Wellness',
            index: 3,
          ),
          _buildModernDrawerItem(
            icon: Icons.person_rounded,
            title: 'Profile',
            index: 4,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Divider(),
          ),
          _buildModernNavigationItem(
            icon: Icons.analytics_rounded,
            title: 'Analytics',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnalyticsScreen(),
                ),
              );
            },
          ),
          _buildModernNavigationItem(
            icon: Icons.settings_rounded,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return _buildModernNavigationItem(
                icon: themeProvider.isDarkMode 
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
                title: themeProvider.isDarkMode 
                  ? 'Light Mode' 
                  : 'Dark Mode',
                onTap: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Divider(),
          ),
          _buildModernNavigationItem(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Help & Support coming soon!'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
          _buildModernNavigationItem(
            icon: Icons.info_outline_rounded,
            title: 'About',
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : null,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Resource Guardian',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.account_balance_wallet,
        size: 48,
      ),
      children: [
        const Text(
          'A comprehensive financial management and digital behavior control application.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Features:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text('• Financial transaction tracking'),
        const Text('• Savings goals management'),
        const Text('• Digital wellness monitoring'),
        const Text('• M-Pesa integration'),
        const Text('• Dark/Light theme support'),
      ],
    );
  }
}
