import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { StatusBar } from 'expo-status-bar';
import { Card, Button } from '../../components';
import { COLORS, SIZES, SHADOWS } from '../../styles/constants';
import { Goal, SavingsGoal } from '../../types';

const GoalsScreen = () => {
  const [goals, setGoals] = useState<Goal[]>([]);
  const [savingsGoals, setSavingsGoals] = useState<SavingsGoal[]>([]);
  const [activeTab, setActiveTab] = useState<'personal' | 'savings'>('personal');
  const [loading, setLoading] = useState(true);

  // Mock data for demonstration
  const mockGoals: Goal[] = [
    {
      id: '1',
      title: 'Learn React Native',
      description: 'Complete a comprehensive React Native course',
      category: 'Education',
      priority: 'high',
      status: 'in_progress',
      deadline: '2025-12-31',
      userId: 'user1',
    },
    {
      id: '2',
      title: 'Exercise Daily',
      description: 'Maintain a daily exercise routine for better health',
      category: 'Health',
      priority: 'medium',
      status: 'in_progress',
      userId: 'user1',
    },
    {
      id: '3',
      title: 'Read 12 Books',
      description: 'Read one book per month throughout the year',
      category: 'Personal Development',
      priority: 'low',
      status: 'pending',
      deadline: '2025-12-31',
      userId: 'user1',
    },
  ];

  const mockSavingsGoals: SavingsGoal[] = [
    {
      id: '1',
      name: 'Emergency Fund',
      targetAmount: 10000,
      currentAmount: 6500,
      deadline: '2025-12-31',
      description: 'Build a 6-month emergency fund',
      isActive: true,
      userId: 'user1',
    },
    {
      id: '2',
      name: 'Vacation to Europe',
      targetAmount: 3000,
      currentAmount: 1200,
      deadline: '2025-06-15',
      description: 'Save for a 2-week trip to Europe',
      isActive: true,
      userId: 'user1',
    },
    {
      id: '3',
      name: 'New Laptop',
      targetAmount: 1500,
      currentAmount: 800,
      deadline: '2025-03-01',
      description: 'Save for a new MacBook Pro',
      isActive: true,
      userId: 'user1',
    },
  ];

  useEffect(() => {
    loadGoals();
  }, []);

  const loadGoals = async () => {
    try {
      // In a real app, you would fetch from the API
      setGoals(mockGoals);
      setSavingsGoals(mockSavingsGoals);
    } catch (error) {
      console.error('Error loading goals:', error);
      Alert.alert('Error', 'Failed to load goals');
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

  const getProgressPercentage = (current: number, target: number) => {
    return Math.min((current / target) * 100, 100);
  };

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high':
        return COLORS.error;
      case 'medium':
        return COLORS.warning;
      case 'low':
        return COLORS.success;
      default:
        return COLORS.gray500;
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed':
        return COLORS.success;
      case 'in_progress':
        return COLORS.primary;
      case 'pending':
        return COLORS.gray500;
      default:
        return COLORS.gray500;
    }
  };

  const renderPersonalGoal = (goal: Goal) => (
    <TouchableOpacity key={goal.id} style={styles.goalCard}>
      <View style={styles.goalHeader}>
        <View style={styles.goalTitleRow}>
          <Text style={styles.goalTitle}>{goal.title}</Text>
          <View style={[styles.priorityBadge, { backgroundColor: getPriorityColor(goal.priority) }]}>
            <Text style={styles.priorityText}>{goal.priority.toUpperCase()}</Text>
          </View>
        </View>
        <View style={styles.goalMeta}>
          <View style={[styles.statusBadge, { backgroundColor: getStatusColor(goal.status) + '20' }]}>
            <Text style={[styles.statusText, { color: getStatusColor(goal.status) }]}>
              {goal.status.replace('_', ' ').toUpperCase()}
            </Text>
          </View>
        </View>
      </View>
      <Text style={styles.goalDescription}>{goal.description}</Text>
      <View style={styles.goalFooter}>
        <Text style={styles.goalCategory}>{goal.category}</Text>
        {goal.deadline && (
          <Text style={styles.goalDeadline}>Due: {formatDate(goal.deadline)}</Text>
        )}
      </View>
    </TouchableOpacity>
  );

  const renderSavingsGoal = (goal: SavingsGoal) => (
    <TouchableOpacity key={goal.id} style={styles.goalCard}>
      <View style={styles.goalHeader}>
        <Text style={styles.goalTitle}>{goal.name}</Text>
        <Text style={styles.goalAmount}>
          {formatCurrency(goal.currentAmount)} / {formatCurrency(goal.targetAmount)}
        </Text>
      </View>
      {goal.description && (
        <Text style={styles.goalDescription}>{goal.description}</Text>
      )}
      <View style={styles.progressContainer}>
        <View style={styles.progressBar}>
          <View
            style={[
              styles.progressFill,
              { width: `${getProgressPercentage(goal.currentAmount, goal.targetAmount)}%` },
            ]}
          />
        </View>
        <Text style={styles.progressText}>
          {getProgressPercentage(goal.currentAmount, goal.targetAmount).toFixed(1)}%
        </Text>
      </View>
      <View style={styles.goalFooter}>
        <Text style={styles.goalDeadline}>Target: {formatDate(goal.deadline)}</Text>
        <Text style={styles.remainingAmount}>
          {formatCurrency(goal.targetAmount - goal.currentAmount)} remaining
        </Text>
      </View>
    </TouchableOpacity>
  );

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <Text>Loading goals...</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="dark" />
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Goals</Text>
        <TouchableOpacity style={styles.addButton}>
          <MaterialIcons name="add" size={SIZES.iconMd} color={COLORS.background} />
        </TouchableOpacity>
      </View>

      {/* Tab Selector */}
      <View style={styles.tabContainer}>
        <TouchableOpacity
          style={[styles.tab, activeTab === 'personal' && styles.activeTab]}
          onPress={() => setActiveTab('personal')}
        >
          <Text style={[styles.tabText, activeTab === 'personal' && styles.activeTabText]}>
            Personal Goals
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.tab, activeTab === 'savings' && styles.activeTab]}
          onPress={() => setActiveTab('savings')}
        >
          <Text style={[styles.tabText, activeTab === 'savings' && styles.activeTabText]}>
            Savings Goals
          </Text>
        </TouchableOpacity>
      </View>

      <ScrollView
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        {activeTab === 'personal' ? (
          goals.length > 0 ? (
            goals.map(renderPersonalGoal)
          ) : (
            <View style={styles.emptyContainer}>
              <MaterialIcons name="track-changes" size={SIZES.iconXl} color={COLORS.gray400} />
              <Text style={styles.emptyText}>No personal goals yet</Text>
              <Text style={styles.emptySubtext}>Start by setting your first goal</Text>
            </View>
          )
        ) : (
          savingsGoals.length > 0 ? (
            savingsGoals.map(renderSavingsGoal)
          ) : (
            <View style={styles.emptyContainer}>
              <MaterialIcons name="savings" size={SIZES.iconXl} color={COLORS.gray400} />
              <Text style={styles.emptyText}>No savings goals yet</Text>
              <Text style={styles.emptySubtext}>Create your first savings goal</Text>
            </View>
          )
        )}
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
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: SIZES.lg,
    paddingVertical: SIZES.md,
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
  tabContainer: {
    flexDirection: 'row',
    marginHorizontal: SIZES.lg,
    marginBottom: SIZES.md,
    backgroundColor: COLORS.backgroundSecondary,
    borderRadius: SIZES.radiusSm,
    padding: SIZES.xs,
  },
  tab: {
    flex: 1,
    paddingVertical: SIZES.sm,
    alignItems: 'center',
    borderRadius: SIZES.radiusXs,
  },
  activeTab: {
    backgroundColor: COLORS.background,
    ...SHADOWS.small,
  },
  tabText: {
    fontSize: SIZES.fontSm,
    fontWeight: '500',
    color: COLORS.textSecondary,
  },
  activeTabText: {
    color: COLORS.primary,
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    paddingHorizontal: SIZES.lg,
    paddingBottom: SIZES.xl,
  },
  goalCard: {
    backgroundColor: COLORS.cardBackground,
    borderRadius: SIZES.radiusMd,
    padding: SIZES.lg,
    marginBottom: SIZES.md,
    ...SHADOWS.small,
  },
  goalHeader: {
    marginBottom: SIZES.md,
  },
  goalTitleRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: SIZES.sm,
  },
  goalTitle: {
    fontSize: SIZES.fontLg,
    fontWeight: '600',
    color: COLORS.textPrimary,
    flex: 1,
    marginRight: SIZES.sm,
  },
  goalAmount: {
    fontSize: SIZES.fontSm,
    fontWeight: '500',
    color: COLORS.textSecondary,
  },
  goalMeta: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  priorityBadge: {
    paddingHorizontal: SIZES.sm,
    paddingVertical: SIZES.xs,
    borderRadius: SIZES.radiusXs,
  },
  priorityText: {
    fontSize: SIZES.fontXs,
    fontWeight: 'bold',
    color: COLORS.background,
  },
  statusBadge: {
    paddingHorizontal: SIZES.sm,
    paddingVertical: SIZES.xs,
    borderRadius: SIZES.radiusXs,
  },
  statusText: {
    fontSize: SIZES.fontXs,
    fontWeight: '600',
  },
  goalDescription: {
    fontSize: SIZES.fontMd,
    color: COLORS.textSecondary,
    marginBottom: SIZES.md,
    lineHeight: 20,
  },
  progressContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: SIZES.md,
  },
  progressBar: {
    flex: 1,
    height: 8,
    backgroundColor: COLORS.gray200,
    borderRadius: SIZES.radiusXs,
    marginRight: SIZES.sm,
  },
  progressFill: {
    height: '100%',
    backgroundColor: COLORS.primary,
    borderRadius: SIZES.radiusXs,
  },
  progressText: {
    fontSize: SIZES.fontSm,
    fontWeight: '600',
    color: COLORS.textPrimary,
    minWidth: 40,
    textAlign: 'right',
  },
  goalFooter: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  goalCategory: {
    fontSize: SIZES.fontSm,
    color: COLORS.primary,
    fontWeight: '500',
  },
  goalDeadline: {
    fontSize: SIZES.fontSm,
    color: COLORS.textLight,
  },
  remainingAmount: {
    fontSize: SIZES.fontSm,
    color: COLORS.textSecondary,
    fontWeight: '500',
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

export default GoalsScreen;
