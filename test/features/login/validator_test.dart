import 'package:flutter_test/flutter_test.dart';
import 'package:test_driven_development/features/login/utility/validator.dart';

void main() {
  group("Validator -", () {
    test("validate for empty email", () {
      //ARRANGE
      String email = '';

      //ACT
      String? result = Validator.validateEmail(email);

      //ASSERT
      expect(result, "Required field");
    });

    test("validate for invalid email", () {
      //ARRANGE
      String email = 'sdsdsd';

      //ACT
      String? result = Validator.validateEmail(email);

      //ASSERT
      expect(result, "Please enter a valid email");
    });

    test("validate for valid email", () {
      //ARRANGE
      String email = 'dev.basakk6@gmail.com';

      //ACT
      String? result = Validator.validateEmail(email);

      //ASSERT
      expect(result, null);
    });

    test("validate for empty password", () {
      //ARRANGE
      String password = '';

      //ACT
      String? result = Validator.validatePassword(password);

      //ASSERT
      expect(result, "Required field");
    });

    test("validate for invalid password", () {
      //ARRANGE
      String password = '1234567';

      //ACT
      String? result = Validator.validatePassword(password);

      //ASSERT
      expect(result, "Password should be a minimum of 8 characters");
    });

    test("validate for valid password", () {
      //ARRANGE
      String password = '12345678';

      //ACT
      String? result = Validator.validatePassword(password);

      //ASSERT
      expect(result, null);
    });
  });
}
