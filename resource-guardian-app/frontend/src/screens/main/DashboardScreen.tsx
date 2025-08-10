import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  RefreshControl,
  Dimensions,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { MaterialIcons } from '@expo/vector-icons';
import { StatusBar } from 'expo-status-bar';
import { Card } from '../../components';
import { COLORS, SIZES, SHADOWS } from '../../styles/constants';
import { DashboardData, Transaction, SavingsGoal } from '../../types';

const { width } = Dimensions.get('window');

const DashboardScreen = () => {
  const [dashboardData, setDashboardData] = useState<DashboardData | null>(null);
  const [refreshing, setRefreshing] = useState(false);
  const [loading, setLoading] = useState(true);

  // Mock data for demonstration
  const mockData: DashboardData = {
    totalBalance: 15420.50,
    monthlyIncome: 5200.00,
    monthlyExpenses: 3180.25,
    savingsGoals: [
      {
        id: '1',
        name: 'Emergency Fund',
        targetAmount: 10000,
        currentAmount: 6500,
        deadline: '2025-12-31',
        isActive: true,
        userId: 'user1',
      },
      {
        id: '2',
        name: 'Vacation',
        targetAmount: 3000,
        currentAmount: 1200,
        deadline: '2025-06-15',
        isActive: true,
        userId: 'user1',
      },
    ],
    recentTransactions: [
      {
        id: '1',
        amount: -85.50,
        description: 'Grocery Shopping',
        category: 'Food',
        type: 'expense',
        date: '2025-08-09',
        userId: 'user1',
      },
      {
        id: '2',
        amount: 2600.00,
        description: 'Salary',
        category: 'Income',
        type: 'income',
        date: '2025-08-01',
        userId: 'user1',
      },
    ],
    goals: [],
    appUsage: [],
  };

  useEffect(() => {
    loadDashboardData();
  }, []);

  const loadDashboardData = async () => {
    try {
      // In a real app, you would fetch from the API
      // const data = await apiService.getDashboardData();
      setDashboardData(mockData);
    } catch (error) {
      console.error('Error loading dashboard data:', error);
    } finally {
      setLoading(false);
    }
  };

  const onRefresh = async () => {
    setRefreshing(true);
    await loadDashboardData();
    setRefreshing(false);
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  const getProgressPercentage = (current: number, target: number) => {
    return Math.min((current / target) * 100, 100);
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <Text>Loading...</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="light" />
      <ScrollView
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContent}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
        showsVerticalScrollIndicator={false}
      >
        {/* Header with Balance */}
        <LinearGradient
          colors={[COLORS.gradientStart, COLORS.gradientEnd]}
          style={styles.headerGradient}
        >
          <View style={styles.header}>
            <Text style={styles.welcomeText}>Welcome back!</Text>
            <Text style={styles.balanceLabel}>Total Balance</Text>
            <Text style={styles.balanceAmount}>
              {formatCurrency(dashboardData?.totalBalance || 0)}
            </Text>
          </View>
        </LinearGradient>

        <View style={styles.content}>
          {/* Quick Stats */}
          <View style={styles.statsRow}>
            <Card style={styles.statCard}>
              <MaterialIcons name="trending-up" size={SIZES.iconLg} color={COLORS.success} />
              <Text style={styles.statLabel}>Income</Text>
              <Text style={styles.statAmount}>
                {formatCurrency(dashboardData?.monthlyIncome || 0)}
              </Text>
            </Card>
            <Card style={styles.statCard}>
              <MaterialIcons name="trending-down" size={SIZES.iconLg} color={COLORS.error} />
              <Text style={styles.statLabel}>Expenses</Text>
              <Text style={styles.statAmount}>
                {formatCurrency(dashboardData?.monthlyExpenses || 0)}
              </Text>
            </Card>
          </View>

          {/* Savings Goals */}
          <Card title="Savings Goals" style={styles.section}>
            {dashboardData?.savingsGoals.map((goal) => (
              <View key={goal.id} style={styles.goalItem}>
                <View style={styles.goalHeader}>
                  <Text style={styles.goalName}>{goal.name}</Text>
                  <Text style={styles.goalAmount}>
                    {formatCurrency(goal.currentAmount)} / {formatCurrency(goal.targetAmount)}
                  </Text>
                </View>
                <View style={styles.progressBar}>
                  <View
                    style={[
                      styles.progressFill,
                      { width: `${getProgressPercentage(goal.currentAmount, goal.targetAmount)}%` },
                    ]}
                  />
                </View>
                <Text style={styles.progressText}>
                  {getProgressPercentage(goal.currentAmount, goal.targetAmount).toFixed(1)}% Complete
                </Text>
              </View>
            ))}
          </Card>

          {/* Recent Transactions */}
          <Card title="Recent Transactions" style={styles.section}>
            {dashboardData?.recentTransactions.map((transaction) => (
              <View key={transaction.id} style={styles.transactionItem}>
                <View style={styles.transactionIcon}>
                  <MaterialIcons
                    name={transaction.type === 'income' ? 'add' : 'remove'}
                    size={SIZES.iconSm}
                    color={transaction.type === 'income' ? COLORS.success : COLORS.error}
                  />
                </View>
                <View style={styles.transactionInfo}>
                  <Text style={styles.transactionDescription}>{transaction.description}</Text>
                  <Text style={styles.transactionCategory}>{transaction.category}</Text>
                </View>
                <Text
                  style={[
                    styles.transactionAmount,
                    transaction.type === 'income' ? styles.incomeAmount : styles.expenseAmount,
                  ]}
                >
                  {transaction.type === 'income' ? '+' : '-'}
                  {formatCurrency(Math.abs(transaction.amount))}
                </Text>
              </View>
            ))}
          </Card>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.background,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    paddingBottom: SIZES.xl,
  },
  headerGradient: {
    paddingTop: SIZES.lg,
    paddingBottom: SIZES.xxl,
    borderBottomLeftRadius: SIZES.radiusXl,
    borderBottomRightRadius: SIZES.radiusXl,
  },
  header: {
    paddingHorizontal: SIZES.lg,
    alignItems: 'center',
  },
  welcomeText: {
    fontSize: SIZES.fontLg,
    color: COLORS.background,
    opacity: 0.9,
    marginBottom: SIZES.sm,
  },
  balanceLabel: {
    fontSize: SIZES.fontSm,
    color: COLORS.background,
    opacity: 0.8,
    marginBottom: SIZES.xs,
  },
  balanceAmount: {
    fontSize: SIZES.font4Xl,
    fontWeight: 'bold',
    color: COLORS.background,
  },
  content: {
    padding: SIZES.lg,
    marginTop: -SIZES.lg,
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: SIZES.lg,
  },
  statCard: {
    flex: 1,
    marginHorizontal: SIZES.xs,
    alignItems: 'center',
    padding: SIZES.lg,
  },
  statLabel: {
    fontSize: SIZES.fontSm,
    color: COLORS.textSecondary,
    marginTop: SIZES.sm,
    marginBottom: SIZES.xs,
  },
  statAmount: {
    fontSize: SIZES.fontLg,
    fontWeight: '600',
    color: COLORS.textPrimary,
  },
  section: {
    marginBottom: SIZES.lg,
  },
  goalItem: {
    marginBottom: SIZES.lg,
  },
  goalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: SIZES.sm,
  },
  goalName: {
    fontSize: SIZES.fontMd,
    fontWeight: '600',
    color: COLORS.textPrimary,
  },
  goalAmount: {
    fontSize: SIZES.fontSm,
    color: COLORS.textSecondary,
  },
  progressBar: {
    height: 8,
    backgroundColor: COLORS.gray200,
    borderRadius: SIZES.radiusXs,
    marginBottom: SIZES.xs,
  },
  progressFill: {
    height: '100%',
    backgroundColor: COLORS.primary,
    borderRadius: SIZES.radiusXs,
  },
  progressText: {
    fontSize: SIZES.fontXs,
    color: COLORS.textSecondary,
    textAlign: 'right',
  },
  transactionItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: SIZES.md,
  },
  transactionIcon: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: COLORS.backgroundSecondary,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: SIZES.md,
  },
  transactionInfo: {
    flex: 1,
  },
  transactionDescription: {
    fontSize: SIZES.fontMd,
    fontWeight: '500',
    color: COLORS.textPrimary,
    marginBottom: SIZES.xs,
  },
  transactionCategory: {
    fontSize: SIZES.fontSm,
    color: COLORS.textSecondary,
  },
  transactionAmount: {
    fontSize: SIZES.fontMd,
    fontWeight: '600',
  },
  incomeAmount: {
    color: COLORS.success,
  },
  expenseAmount: {
    color: COLORS.error,
  },
});

export default DashboardScreen;
