import 'package:flutter_test/flutter_test.dart';
import 'package:pro/Screen/login_screen.dart';

void main() {
  test('empty email returns error string', () {
    var result = EmailFieldValidator.validate('');
    expect(result, 'Invalid Email');
  });

  test('non valid format email returns error string', () {
    var result = EmailFieldValidator.validate('thisIsNotRightFormat');
    expect(result, 'Invalid Email');
  });

  test('valid format email returns null', () {
    var result = EmailFieldValidator.validate('franci@gmail.com');
    expect(result, null);
  });

  test('empty email returns error string', () {
    var result = PasswordFieldValidator.validate('');
    expect(result, 'Password can\'t be empty or shorter than 6 characters');
  });

  test('short password returns error string', () {
    var result = PasswordFieldValidator.validate('12345');
    expect(result, 'Password can\'t be empty or shorter than 6 characters');
  });
}
