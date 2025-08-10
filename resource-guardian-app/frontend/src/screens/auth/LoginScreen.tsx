import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  Alert,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { StatusBar } from 'expo-status-bar';
import { Button, Input, Card } from '../../components';
import { COLORS, SIZES } from '../../styles/constants';
import { AuthRequest } from '../../types';
import { apiService } from '../../services/api';

const LoginScreen = ({ navigation }: any) => {
  const [formData, setFormData] = useState<AuthRequest>({
    username: '',
    password: '',
  });
  const [errors, setErrors] = useState<Partial<AuthRequest>>({});
  const [loading, setLoading] = useState(false);

  const validateForm = (): boolean => {
    const newErrors: Partial<AuthRequest> = {};

    if (!formData.username.trim()) {
      newErrors.username = 'Username is required';
    }

    if (!formData.password) {
      newErrors.password = 'Password is required';
    } else if (formData.password.length < 6) {
      newErrors.password = 'Password must be at least 6 characters';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleLogin = async () => {
    if (!validateForm()) return;

    setLoading(true);
    try {
      const response = await apiService.login(formData);
      // Handle successful login
      Alert.alert('Success', 'Login successful!');
      // Navigate to main app or update auth context
    } catch (error) {
      Alert.alert('Error', 'Login failed. Please check your credentials.');
      console.error('Login error:', error);
    } finally {
      setLoading(false);
    }
  };

  const updateField = (field: keyof AuthRequest, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: undefined }));
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="light" />
      <LinearGradient
        colors={[COLORS.gradientStart, COLORS.gradientEnd]}
        style={styles.gradient}
      >
        <KeyboardAvoidingView
          behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
          style={styles.keyboardView}
        >
          <ScrollView
            contentContainerStyle={styles.scrollContent}
            showsVerticalScrollIndicator={false}
          >
            <View style={styles.header}>
              <Text style={styles.title}>Resource Guardian</Text>
              <Text style={styles.subtitle}>
                Manage your resources intelligently
              </Text>
            </View>

            <Card style={styles.formCard}>
              <Text style={styles.formTitle}>Welcome Back</Text>
              
              <Input
                label="Username"
                value={formData.username}
                onChangeText={(value) => updateField('username', value)}
                error={errors.username}
                icon="person"
                placeholder="Enter your username"
                autoCapitalize="none"
                autoCorrect={false}
              />

              <Input
                label="Password"
                value={formData.password}
                onChangeText={(value) => updateField('password', value)}
                error={errors.password}
                icon="lock"
                placeholder="Enter your password"
                isPassword
              />

              <Button
                title="Sign In"
                onPress={handleLogin}
                loading={loading}
                gradient
                style={styles.loginButton}
              />

              <View style={styles.footer}>
                <Text style={styles.footerText}>Don't have an account? </Text>
                <Button
                  title="Sign Up"
                  onPress={() => navigation.navigate('Register')}
                  variant="ghost"
                  size="small"
                />
              </View>
            </Card>
          </ScrollView>
        </KeyboardAvoidingView>
      </LinearGradient>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  gradient: {
    flex: 1,
  },
  keyboardView: {
    flex: 1,
  },
  scrollContent: {
    flexGrow: 1,
    justifyContent: 'center',
    padding: SIZES.lg,
  },
  header: {
    alignItems: 'center',
    marginBottom: SIZES.xxl,
  },
  title: {
    fontSize: SIZES.font4Xl,
    fontWeight: 'bold',
    color: COLORS.background,
    textAlign: 'center',
    marginBottom: SIZES.sm,
  },
  subtitle: {
    fontSize: SIZES.fontLg,
    color: COLORS.background,
    textAlign: 'center',
    opacity: 0.9,
  },
  formCard: {
    backgroundColor: COLORS.background,
    borderRadius: SIZES.radiusLg,
    padding: SIZES.xl,
  },
  formTitle: {
    fontSize: SIZES.font2Xl,
    fontWeight: 'bold',
    color: COLORS.textPrimary,
    textAlign: 'center',
    marginBottom: SIZES.lg,
  },
  loginButton: {
    marginTop: SIZES.md,
    marginBottom: SIZES.lg,
  },
  footer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  footerText: {
    fontSize: SIZES.fontSm,
    color: COLORS.textSecondary,
  },
});

export default LoginScreen;
