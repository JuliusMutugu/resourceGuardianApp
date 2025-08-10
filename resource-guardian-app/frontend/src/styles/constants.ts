export const COLORS = {
  primary: '#4A90E2',
  primaryDark: '#357ABD',
  secondary: '#50E3C2',
  accent: '#F5A623',
  success: '#7ED321',
  warning: '#F5A623',
  error: '#D0021B',
  
  // Grays
  gray100: '#F8F9FA',
  gray200: '#E9ECEF',
  gray300: '#DEE2E6',
  gray400: '#CED4DA',
  gray500: '#ADB5BD',
  gray600: '#6C757D',
  gray700: '#495057',
  gray800: '#343A40',
  gray900: '#212529',
  
  // Background
  background: '#FFFFFF',
  backgroundSecondary: '#F8F9FA',
  
  // Text
  textPrimary: '#212529',
  textSecondary: '#6C757D',
  textLight: '#ADB5BD',
  
  // Card
  cardBackground: '#FFFFFF',
  cardShadow: 'rgba(0, 0, 0, 0.1)',
  
  // Transparent
  transparent: 'transparent',
  
  // Gradient colors
  gradientStart: '#4A90E2',
  gradientEnd: '#50E3C2',
};

export const SIZES = {
  // Font sizes
  fontXs: 12,
  fontSm: 14,
  fontMd: 16,
  fontLg: 18,
  fontXl: 20,
  font2Xl: 24,
  font3Xl: 30,
  font4Xl: 36,
  
  // Spacing
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
  
  // Border radius
  radiusXs: 4,
  radiusSm: 8,
  radiusMd: 12,
  radiusLg: 16,
  radiusXl: 24,
  radiusFull: 9999,
  
  // Icon sizes
  iconXs: 16,
  iconSm: 20,
  iconMd: 24,
  iconLg: 32,
  iconXl: 40,
  
  // Screen dimensions (will be updated dynamically)
  screenWidth: 375,
  screenHeight: 812,
};

export const FONTS = {
  regular: 'System',
  medium: 'System',
  bold: 'System',
  light: 'System',
};

export const SHADOWS = {
  small: {
    shadowColor: COLORS.gray900,
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3,
    elevation: 2,
  },
  medium: {
    shadowColor: COLORS.gray900,
    shadowOffset: {
      width: 0,
      height: 4,
    },
    shadowOpacity: 0.15,
    shadowRadius: 6,
    elevation: 4,
  },
  large: {
    shadowColor: COLORS.gray900,
    shadowOffset: {
      width: 0,
      height: 8,
    },
    shadowOpacity: 0.2,
    shadowRadius: 12,
    elevation: 8,
  },
};

export const ANIMATION = {
  duration: {
    fast: 200,
    normal: 300,
    slow: 500,
  },
};

// API Configuration
export const API_CONFIG = {
  BASE_URL: __DEV__ ? 'http://localhost:8080/api' : 'https://your-production-api.com/api',
  TIMEOUT: 10000,
};

export const SCREEN_NAMES = {
  // Auth
  LOGIN: 'Login',
  REGISTER: 'Register',
  
  // Main Tabs
  DASHBOARD: 'Dashboard',
  TRANSACTIONS: 'Transactions',
  GOALS: 'Goals',
  PROFILE: 'Profile',
  
  // Screens
  TRANSACTION_DETAIL: 'TransactionDetail',
  ADD_TRANSACTION: 'AddTransaction',
  GOAL_DETAIL: 'GoalDetail',
  ADD_GOAL: 'AddGoal',
  SAVINGS_GOALS: 'SavingsGoals',
  ADD_SAVINGS_GOAL: 'AddSavingsGoal',
  SETTINGS: 'Settings',
} as const;
