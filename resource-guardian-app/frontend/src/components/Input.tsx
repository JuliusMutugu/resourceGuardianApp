import React, { useState } from 'react';
import {
  TextInput,
  View,
  Text,
  StyleSheet,
  TextInputProps,
  ViewStyle,
  TextStyle,
  TouchableOpacity,
} from 'react-native';
import { MaterialIcons } from '@expo/vector-icons';
import { COLORS, SIZES } from '../styles/constants';

interface InputProps extends TextInputProps {
  label?: string;
  error?: string;
  containerStyle?: ViewStyle;
  labelStyle?: TextStyle;
  inputStyle?: TextStyle;
  errorStyle?: TextStyle;
  icon?: keyof typeof MaterialIcons.glyphMap;
  rightIcon?: keyof typeof MaterialIcons.glyphMap;
  onRightIconPress?: () => void;
  isPassword?: boolean;
}

export const Input: React.FC<InputProps> = ({
  label,
  error,
  containerStyle,
  labelStyle,
  inputStyle,
  errorStyle,
  icon,
  rightIcon,
  onRightIconPress,
  isPassword = false,
  ...props
}) => {
  const [isPasswordVisible, setIsPasswordVisible] = useState(false);

  const togglePasswordVisibility = () => {
    setIsPasswordVisible(!isPasswordVisible);
  };

  const actualRightIcon = isPassword
    ? (isPasswordVisible ? 'visibility-off' : 'visibility')
    : rightIcon;

  const onActualRightIconPress = isPassword
    ? togglePasswordVisibility
    : onRightIconPress;

  return (
    <View style={[styles.container, containerStyle]}>
      {label && (
        <Text style={[styles.label, labelStyle]}>{label}</Text>
      )}
      <View style={[
        styles.inputContainer,
        error && styles.errorContainer,
      ]}>
        {icon && (
          <MaterialIcons
            name={icon}
            size={SIZES.iconSm}
            color={COLORS.gray500}
            style={styles.leftIcon}
          />
        )}
        <TextInput
          style={[
            styles.input,
            icon && styles.inputWithLeftIcon,
            actualRightIcon && styles.inputWithRightIcon,
            inputStyle,
          ]}
          placeholderTextColor={COLORS.gray400}
          secureTextEntry={isPassword && !isPasswordVisible}
          {...props}
        />
        {actualRightIcon && (
          <TouchableOpacity
            onPress={onActualRightIconPress}
            style={styles.rightIcon}
          >
            <MaterialIcons
              name={actualRightIcon}
              size={SIZES.iconSm}
              color={COLORS.gray500}
            />
          </TouchableOpacity>
        )}
      </View>
      {error && (
        <Text style={[styles.error, errorStyle]}>{error}</Text>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: SIZES.sm,
  },
  label: {
    fontSize: SIZES.fontSm,
    fontWeight: '500',
    color: COLORS.textPrimary,
    marginBottom: SIZES.xs,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.backgroundSecondary,
    borderRadius: SIZES.radiusSm,
    borderWidth: 1,
    borderColor: COLORS.gray300,
    minHeight: 48,
  },
  errorContainer: {
    borderColor: COLORS.error,
  },
  input: {
    flex: 1,
    fontSize: SIZES.fontMd,
    color: COLORS.textPrimary,
    paddingHorizontal: SIZES.md,
    paddingVertical: SIZES.sm,
  },
  inputWithLeftIcon: {
    paddingLeft: SIZES.xs,
  },
  inputWithRightIcon: {
    paddingRight: SIZES.xs,
  },
  leftIcon: {
    marginLeft: SIZES.md,
  },
  rightIcon: {
    padding: SIZES.sm,
    marginRight: SIZES.xs,
  },
  error: {
    fontSize: SIZES.fontXs,
    color: COLORS.error,
    marginTop: SIZES.xs,
  },
});
