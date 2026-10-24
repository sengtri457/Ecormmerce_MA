import 'package:flutter_test/flutter_test.dart';
import 'package:ecormmerce_ma/helpers/validators.dart';

void main() {
  group('Validators', () {
    test('required validation', () {
      expect(Validators.required(null), isNotNull);
      expect(Validators.required(''), isNotNull);
      expect(Validators.required('   '), isNotNull);
      expect(Validators.required('valid input'), isNull);
    });

    test('email validation', () {
      expect(Validators.email(null), isNotNull);
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('test@'), isNotNull);
      expect(Validators.email('test@example.com'), isNull);
      expect(Validators.email('  user@mastudio.com  '), isNull);
    });

    test('password validation', () {
      expect(Validators.password(null), isNotNull);
      expect(Validators.password('short'), isNotNull);
      expect(Validators.password('with spaces 123'), isNotNull);
      expect(Validators.password('validpass123'), isNull);

      // Strict mode
      expect(Validators.password('simplepass1', strict: true), isNotNull); // missing uppercase & special
      expect(Validators.password('ValidPass123!', strict: true), isNull);
    });

    test('confirmPassword validation', () {
      expect(Validators.confirmPassword(null, 'password123'), isNotNull);
      expect(Validators.confirmPassword('different', 'password123'), isNotNull);
      expect(Validators.confirmPassword('password123', 'password123'), isNull);
    });

    test('username validation', () {
      expect(Validators.username(null), isNotNull);
      expect(Validators.username('ab'), isNotNull);
      expect(Validators.username('alice'), isNull);
    });

    test('phone validation', () {
      expect(Validators.phone(null, isRequired: false), isNull);
      expect(Validators.phone(null, isRequired: true), isNotNull);
      expect(Validators.phone('123'), isNotNull);
      expect(Validators.phone('+1 (555) 123-4567'), isNull);
      expect(Validators.phone('0123456789'), isNull);
    });

    test('acceptedTerms validation', () {
      expect(Validators.acceptedTerms(null), isNotNull);
      expect(Validators.acceptedTerms(false), isNotNull);
      expect(Validators.acceptedTerms(true), isNull);
    });
  });
}
