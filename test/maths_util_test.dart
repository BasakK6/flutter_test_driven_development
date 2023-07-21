import 'package:flutter_test/flutter_test.dart';
import 'package:test_driven_development/maths_util.dart';

void main() {
  group("Maths util -", () {
    test("check for 2 number addition", () {
      //ARRANGE
      int a = 10;
      int b = 10;

      //ACT
      int result = add(a, b);

      //ASSERT
      expect(result, 20);
    });

    test("check for 2 number multiplication", () {
      //ARRANGE
      int a = 10;
      int b = 10;

      //ACT
      int result = multiply(a, b);

      //ASSERT
      expect(result, 100);
    });
  });
}
