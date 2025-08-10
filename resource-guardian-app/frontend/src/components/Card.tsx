import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ViewStyle,
  TextStyle,
} from 'react-native';
import { COLORS, SIZES, SHADOWS } from '../styles/constants';

interface CardProps {
  children: React.ReactNode;
  style?: ViewStyle;
  title?: string;
  titleStyle?: TextStyle;
  padding?: keyof typeof SIZES;
  shadow?: boolean;
}

export const Card: React.FC<CardProps> = ({
  children,
  style,
  title,
  titleStyle,
  padding = 'md',
  shadow = true,
}) => {
  return (
    <View style={[
      styles.container,
      shadow && SHADOWS.small,
      { padding: SIZES[padding] },
      style,
    ]}>
      {title && (
        <Text style={[styles.title, titleStyle]}>{title}</Text>
      )}
      {children}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: COLORS.cardBackground,
    borderRadius: SIZES.radiusMd,
    marginVertical: SIZES.xs,
  },
  title: {
    fontSize: SIZES.fontLg,
    fontWeight: '600',
    color: COLORS.textPrimary,
    marginBottom: SIZES.md,
  },
});
