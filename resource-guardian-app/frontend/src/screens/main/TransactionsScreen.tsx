import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  FlatList,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { StatusBar } from 'expo-status-bar';
import { Card, Button } from '../../components';
import { COLORS, SIZES, SHADOWS } from '../../styles/constants';
import { Transaction } from '../../types';

const TransactionsScreen = () => {
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loading, setLoading] = useState(true);

  // Mock data for demonstration
  const mockTransactions: Transaction[] = [
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
    {
      id: '3',
      amount: -120.00,
      description: 'Electric Bill',
      category: 'Utilities',
      type: 'expense',
      date: '2025-07-28',
      userId: 'user1',
    },
    {
      id: '4',
      amount: -45.99,
      description: 'Netflix Subscription',
      category: 'Entertainment',
      type: 'expense',
      date: '2025-07-25',
      userId: 'user1',
    },
    {
      id: '5',
      amount: 500.00,
      description: 'Freelance Project',
      category: 'Income',
      type: 'income',
      date: '2025-07-20',
      userId: 'user1',
    },
  ];

  useEffect(() => {
    loadTransactions();
  }, []);

  const loadTransactions = async () => {
    try {
      // In a real app, you would fetch from the API
      // const data = await apiService.getTransactions();
      setTransactions(mockTransactions);
    } catch (error) {
      console.error('Error loading transactions:', error);
      Alert.alert('Error', 'Failed to load transactions');
    } finally {
      setLoading(false);
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    });
  };

  const getCategoryIcon = (category: string) => {
    const iconMap: { [key: string]: keyof typeof MaterialIcons.glyphMap } = {
      Food: 'restaurant',
      Income: 'attach-money',
      Utilities: 'flash-on',
      Entertainment: 'movie',
      Transport: 'directions-car',
      Health: 'local-hospital',
      Shopping: 'shopping-cart',
      Education: 'school',
    };
    return iconMap[category] || 'account-balance-wallet';
  };

  const renderTransaction = ({ item }: { item: Transaction }) => (
    <TouchableOpacity style={styles.transactionItem}>
      <View style={[
        styles.iconContainer,
        { backgroundColor: item.type === 'income' ? COLORS.success + '20' : COLORS.error + '20' }
      ]}>
        <MaterialIcons
          name={getCategoryIcon(item.category)}
          size={SIZES.iconSm}
          color={item.type === 'income' ? COLORS.success : COLORS.error}
        />
      </View>
      <View style={styles.transactionInfo}>
        <Text style={styles.description}>{item.description}</Text>
        <Text style={styles.category}>{item.category}</Text>
        <Text style={styles.date}>{formatDate(item.date)}</Text>
      </View>
      <Text style={[
        styles.amount,
        item.type === 'income' ? styles.incomeAmount : styles.expenseAmount
      ]}>
        {item.type === 'income' ? '+' : ''}
        {formatCurrency(item.amount)}
      </Text>
    </TouchableOpacity>
  );

  const calculateTotals = () => {
    const income = transactions
      .filter(t => t.type === 'income')
      .reduce((sum, t) => sum + t.amount, 0);
    
    const expenses = transactions
      .filter(t => t.type === 'expense')
      .reduce((sum, t) => sum + Math.abs(t.amount), 0);

    return { income, expenses };
  };

  const { income, expenses } = calculateTotals();

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <Text>Loading transactions...</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="dark" />
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Transactions</Text>
        <TouchableOpacity style={styles.addButton}>
          <MaterialIcons name="add" size={SIZES.iconMd} color={COLORS.background} />
        </TouchableOpacity>
      </View>

      {/* Summary Cards */}
      <View style={styles.summaryContainer}>
        <Card style={styles.summaryCard}>
          <Text style={styles.summaryLabel}>Income</Text>
          <Text style={[styles.summaryAmount, styles.incomeAmount]}>
            {formatCurrency(income)}
          </Text>
        </Card>
        <Card style={styles.summaryCard}>
          <Text style={styles.summaryLabel}>Expenses</Text>
          <Text style={[styles.summaryAmount, styles.expenseAmount]}>
            {formatCurrency(expenses)}
          </Text>
        </Card>
      </View>

      {/* Transactions List */}
      <FlatList
        data={transactions}
        renderItem={renderTransaction}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.listContent}
        showsVerticalScrollIndicator={false}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <MaterialIcons name="receipt" size={SIZES.iconXl} color={COLORS.gray400} />
            <Text style={styles.emptyText}>No transactions yet</Text>
            <Text style={styles.emptySubtext}>Start by adding your first transaction</Text>
          </View>
        }
      />
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
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: SIZES.lg,
    paddingVertical: SIZES.md,
    backgroundColor: COLORS.background,
  },
  headerTitle: {
    fontSize: SIZES.font2Xl,
    fontWeight: 'bold',
    color: COLORS.textPrimary,
  },
  addButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: COLORS.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  summaryContainer: {
    flexDirection: 'row',
    paddingHorizontal: SIZES.lg,
    marginBottom: SIZES.md,
  },
  summaryCard: {
    flex: 1,
    marginHorizontal: SIZES.xs,
    alignItems: 'center',
    padding: SIZES.lg,
  },
  summaryLabel: {
    fontSize: SIZES.fontSm,
    color: COLORS.textSecondary,
    marginBottom: SIZES.xs,
  },
  summaryAmount: {
    fontSize: SIZES.fontXl,
    fontWeight: 'bold',
  },
  listContent: {
    paddingHorizontal: SIZES.lg,
    paddingBottom: SIZES.xl,
  },
  transactionItem: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.cardBackground,
    borderRadius: SIZES.radiusMd,
    padding: SIZES.md,
    marginBottom: SIZES.sm,
    ...SHADOWS.small,
  },
  iconContainer: {
    width: 48,
    height: 48,
    borderRadius: 24,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: SIZES.md,
  },
  transactionInfo: {
    flex: 1,
  },
  description: {
    fontSize: SIZES.fontMd,
    fontWeight: '600',
    color: COLORS.textPrimary,
    marginBottom: SIZES.xs,
  },
  category: {
    fontSize: SIZES.fontSm,
    color: COLORS.textSecondary,
    marginBottom: SIZES.xs,
  },
  date: {
    fontSize: SIZES.fontXs,
    color: COLORS.textLight,
  },
  amount: {
    fontSize: SIZES.fontLg,
    fontWeight: 'bold',
  },
  incomeAmount: {
    color: COLORS.success,
  },
  expenseAmount: {
    color: COLORS.error,
  },
  emptyContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: SIZES.xxl,
  },
  emptyText: {
    fontSize: SIZES.fontLg,
    fontWeight: '600',
    color: COLORS.textSecondary,
    marginTop: SIZES.md,
    marginBottom: SIZES.xs,
  },
  emptySubtext: {
    fontSize: SIZES.fontSm,
    color: COLORS.textLight,
    textAlign: 'center',
  },
});

export default TransactionsScreen;
