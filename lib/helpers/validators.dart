import 'package:email_validator/email_validator.dart';

class Validators {
  Validators._();

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!EmailValidator.validate(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? password(String? value, {bool strict = false}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (value.contains(' ')) {
      return 'Password must not contain spaces';
    }

    if (strict) {
      if (!RegExp(r'[A-Z]').hasMatch(value)) {
        return 'Password must contain at least 1 uppercase letter';
      }

      if (!RegExp(r'[a-z]').hasMatch(value)) {
        return 'Password must contain at least 1 lowercase letter';
      }

      if (!RegExp(r'[0-9]').hasMatch(value)) {
        return 'Password must contain at least 1 number';
      }

      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]+=;]').hasMatch(value)) {
        return 'Password must contain at least 1 special character';
      }
    }

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? username(String? value, {int minLength = 3}) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    if (value.trim().length < minLength) {
      return 'Username must be at least $minLength characters';
    }

    return null;
  }

  static String? phone(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) return 'Phone number is required';
      return null;
    }

    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleaned.length < 7 ||
        cleaned.length > 15 ||
        !RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  static String? acceptedTerms(
    bool? value, {
    String message = 'You must accept the terms and conditions',
  }) {
    if (value != true) {
      return message;
    }
    return null;
  }
}
