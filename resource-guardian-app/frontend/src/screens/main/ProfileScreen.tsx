import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  TouchableOpacity,
  Alert,
  Image,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { StatusBar } from 'expo-status-bar';
import { Card, Button } from '../../components';
import { COLORS, SIZES, SHADOWS } from '../../styles/constants';
import { User } from '../../types';

const ProfileScreen = () => {
  const [user, setUser] = useState<User>({
    id: 'user1',
    username: 'john_doe',
    email: 'john.doe@example.com',
    firstName: 'John',
    lastName: 'Doe',
  });

  const handleLogout = () => {
    Alert.alert(
      'Logout',
      'Are you sure you want to logout?',
      [
        {
          text: 'Cancel',
          style: 'cancel',
        },
        {
          text: 'Logout',
          style: 'destructive',
          onPress: () => {
            // Handle logout logic
            console.log('User logged out');
          },
        },
      ]
    );
  };

  const menuItems = [
    {
      id: 'edit-profile',
      title: 'Edit Profile',
      icon: 'edit' as keyof typeof MaterialIcons.glyphMap,
      onPress: () => console.log('Edit Profile'),
    },
    {
      id: 'notifications',
      title: 'Notifications',
      icon: 'notifications' as keyof typeof MaterialIcons.glyphMap,
      onPress: () => console.log('Notifications'),
    },
    {
      id: 'security',
      title: 'Security & Privacy',
      icon: 'security' as keyof typeof MaterialIcons.glyphMap,
      onPress: () => console.log('Security'),
    },
    {
      id: 'help',
      title: 'Help & Support',
      icon: 'help' as keyof typeof MaterialIcons.glyphMap,
      onPress: () => console.log('Help'),
    },
    {
      id: 'about',
      title: 'About',
      icon: 'info' as keyof typeof MaterialIcons.glyphMap,
      onPress: () => console.log('About'),
    },
  ];

  const renderMenuItem = (item: typeof menuItems[0]) => (
    <TouchableOpacity
      key={item.id}
      style={styles.menuItem}
      onPress={item.onPress}
    >
      <View style={styles.menuIcon}>
        <MaterialIcons
          name={item.icon}
          size={SIZES.iconSm}
          color={COLORS.primary}
        />
      </View>
      <Text style={styles.menuTitle}>{item.title}</Text>
      <MaterialIcons
        name="chevron-right"
        size={SIZES.iconSm}
        color={COLORS.gray400}
      />
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="dark" />
      
      <ScrollView
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContent}
        showsVerticalScrollIndicator={false}
      >
        {/* Profile Header */}
        <Card style={styles.profileCard}>
          <View style={styles.profileHeader}>
            <View style={styles.avatarContainer}>
              <View style={styles.avatar}>
                <MaterialIcons
                  name="person"
                  size={SIZES.iconXl}
                  color={COLORS.gray500}
                />
              </View>
              <TouchableOpacity style={styles.editAvatarButton}>
                <MaterialIcons
                  name="camera-alt"
                  size={SIZES.iconSm}
                  color={COLORS.background}
                />
              </TouchableOpacity>
            </View>
            <View style={styles.profileInfo}>
              <Text style={styles.userName}>
                {user.firstName} {user.lastName}
              </Text>
              <Text style={styles.userEmail}>{user.email}</Text>
              <Text style={styles.userHandle}>@{user.username}</Text>
            </View>
          </View>
        </Card>

        {/* Quick Stats */}
        <View style={styles.statsContainer}>
          <Card style={styles.statCard}>
            <Text style={styles.statNumber}>12</Text>
            <Text style={styles.statLabel}>Goals</Text>
          </Card>
          <Card style={styles.statCard}>
            <Text style={styles.statNumber}>3</Text>
            <Text style={styles.statLabel}>Completed</Text>
          </Card>
          <Card style={styles.statCard}>
            <Text style={styles.statNumber}>8</Text>
            <Text style={styles.statLabel}>In Progress</Text>
          </Card>
        </View>

        {/* Menu Items */}
        <Card style={styles.menuCard}>
          {menuItems.map(renderMenuItem)}
        </Card>

        {/* App Info */}
        <Card style={styles.infoCard}>
          <Text style={styles.infoTitle}>Resource Guardian</Text>
          <Text style={styles.infoVersion}>Version 1.0.0</Text>
          <Text style={styles.infoDescription}>
            Manage your resources intelligently with our comprehensive tracking and goal-setting features.
          </Text>
        </Card>

        {/* Logout Button */}
        <Button
          title="Logout"
          onPress={handleLogout}
          variant="outline"
          style={styles.logoutButton}
          textStyle={styles.logoutText}
        />
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.background,
  },
  scrollView: {
    flex: 1,
  },
  scrollContent: {
    padding: SIZES.lg,
    paddingBottom: SIZES.xl,
  },
  profileCard: {
    marginBottom: SIZES.lg,
  },
  profileHeader: {
    alignItems: 'center',
  },
  avatarContainer: {
    position: 'relative',
    marginBottom: SIZES.lg,
  },
  avatar: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: COLORS.backgroundSecondary,
    alignItems: 'center',
    justifyContent: 'center',
    ...SHADOWS.medium,
  },
  editAvatarButton: {
    position: 'absolute',
    bottom: 0,
    right: 0,
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: COLORS.primary,
    alignItems: 'center',
    justifyContent: 'center',
    ...SHADOWS.small,
  },
  profileInfo: {
    alignItems: 'center',
  },
  userName: {
    fontSize: SIZES.font2Xl,
    fontWeight: 'bold',
    color: COLORS.textPrimary,
    marginBottom: SIZES.xs,
  },
  userEmail: {
    fontSize: SIZES.fontMd,
    color: COLORS.textSecondary,
    marginBottom: SIZES.xs,
  },
  userHandle: {
    fontSize: SIZES.fontSm,
    color: COLORS.textLight,
  },
  statsContainer: {
    flexDirection: 'row',
    marginBottom: SIZES.lg,
  },
  statCard: {
    flex: 1,
    marginHorizontal: SIZES.xs,
    alignItems: 'center',
    padding: SIZES.lg,
  },
  statNumber: {
    fontSize: SIZES.font2Xl,
    fontWeight: 'bold',
    color: COLORS.primary,
    marginBottom: SIZES.xs,
  },
  statLabel: {
    fontSize: SIZES.fontSm,
    color: COLORS.textSecondary,
    textAlign: 'center',
  },
  menuCard: {
    marginBottom: SIZES.lg,
    padding: 0,
  },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: SIZES.lg,
    paddingVertical: SIZES.md,
    borderBottomWidth: 1,
    borderBottomColor: COLORS.gray200,
  },
  menuIcon: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: COLORS.primary + '20',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: SIZES.md,
  },
  menuTitle: {
    flex: 1,
    fontSize: SIZES.fontMd,
    fontWeight: '500',
    color: COLORS.textPrimary,
  },
  infoCard: {
    alignItems: 'center',
    marginBottom: SIZES.lg,
  },
  infoTitle: {
    fontSize: SIZES.fontXl,
    fontWeight: 'bold',
    color: COLORS.textPrimary,
    marginBottom: SIZES.xs,
  },
  infoVersion: {
    fontSize: SIZES.fontSm,
    color: COLORS.textSecondary,
    marginBottom: SIZES.md,
  },
  infoDescription: {
    fontSize: SIZES.fontSm,
    color: COLORS.textSecondary,
    textAlign: 'center',
    lineHeight: 20,
  },
  logoutButton: {
    borderColor: COLORS.error,
  },
  logoutText: {
    color: COLORS.error,
  },
});

export default ProfileScreen;
