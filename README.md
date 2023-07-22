# test_driven_development

This tutorial is created with the help of a [Udemy course](https://www.udemy.com/course/flutter-testing-unit-widget-integration-testing/) and my personal notes & code additions.

## Test Driven Development

1) Write tests -> Write code -> Refactor -> Write test
2) No code goes into production unless it has associated tests

## Test Driven Development Steps

1) Write single test
2) Compile it. It should fail because you've not written the implementation code.
3) Implement just enough code to get the test to pass
4) Run the test and see it passes (If it fails repeat the steps 3 and 4)
5) Refactor for clarity and remove duplication
6) Repeat from the top

## TDD Benefits
1) Rapid feedback
2) Know when you're finished
3) Change the code with confidence
4) Encapsulate learning
5) Intermediate stability
6) Much less debug time
7) Code proven to meet the requirements
8) Tests become the Safety Net when refactoring code
9) Shorter development cycles
10) Near zero defects
11) Test are documentation (shows others how to use our code)

## Test Codes Structure (AAA)
1) Arrange
2) Act
3) Assert

## TDD in Flutter

Flutter has 3 options for tests. **Unit Tests**, **Widget Tests**, and **Integration Tests** are different types of testing methodologies used to ensure the quality and correctness of the Flutter applications.

## Flutter Unit Testing

Unit tests in Flutter are used to test small, isolated pieces of code, typically at the function or method level. The purpose of unit tests is to verify that individual units of code, such as functions, methods, or classes, work as expected and produce the correct output for a given input. In Flutter, unit tests are written using the built-in testing framework called flutter_test.
Unit tests do not interact with external dependencies like databases, network services, or user interfaces. Instead, they mock or stub these dependencies to focus solely on testing the logic within the unit being tested. Unit tests help catch bugs early in the development process and make it easier to refactor code with confidence.

### Unit Tests in code

Let's say we want a functionality that adds 2 numbers and returns the total like below. We write this function in a file called **maths_util.dart**
```dart
int add(int a, int b){
  return 0; //just enough to compile
}
```

Before the implementation we write the test. So, we create a file called **maths_util_test.dart** under the test folder. We should also give very detailed explanations for the description parameter of the test() function.
```dart
void main(){
  test("check for 2 number addition",(){
    //ARRANGE
    int a =10;
    int b= 10;

    //ACT
    int result = add(a, b);

    //ASSERT
    expect(result, 20);
  });
}
```

The test will fail, and then we implement the code:

```dart
int add(int a, int b){
  return a + b;
}
```

After we run the test again, we see that the test passes.

**NOTE:** TDD is a good practice because **Tests become the Safety Net**. Let's say another developer did not understand our code and changed it. For example they changed the add() implementation to *return a-b;* instead of *return  a+b;*
Running the automated tests will ensure that the code is always working as expected.

Let's say we have another function in the maths_util.dart file like below:

```dart
int multiply(){
  int a = 10;
  int b= 10;
  return a * b;
}
```

One important thing is that we should always write **testable code**. The code above is not testable because the dependencies (a and b variable) are defined in the function body. We should write functions that injects the dependencies (functions should have parameters for the dependent variables). So we changed to function to:

```dart
int multiply(int a, int b){
  return a * b;
}
```

We can then write tests that group multiple tests in a file. This helps us to run the tests all together.


```dart
void main() {
  group("Maths util -", () {
    test("check for 2 numbers addition", () {
      //ARRANGE
      int a = 10;
      int b = 10;

      //ACT
      int result = add(a, b);

      //ASSERT
      expect(result, 20);
    });

    test("check for 2 numbers multiplication", () {
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
```

### USE CASE: Login Screen

Let's say we want to create a login screen for our application. We want to validate our TextFormFields in a Form. For this purpose, let's write validation code and do unit tests. Let's first create **validator.dart** and **validator_test.dart** files.

**validator.dart:**
```dart
class Validator{

  static String? validateEmail(String email){

  }
}
```
We can then write a test that validates empty email address:
**validator_test.dart:**

```dart
void main(){
  test("validate for empty email",(){
    //ARRANGE
    String email = '';

    //ACT
    String? result = Validator.validateEmail(email);

    //ASSERT
    expect(result, "Required field");
  });
}
```


We then implement the code for the validateEmail function:
```dart
class Validator{
  static String? validateEmail(String email){
      if(email.isEmpty){
        return "Required field";
      }
  }
}
```

We can also test for the invalid email address

```dart
void main(){
  test("validate for empty email",(){
    //ARRANGE
    String email = '';

    //ACT
    String? result = Validator.validateEmail(email);

    //ASSERT
    expect(result, "Required field");
  });

  test("validate for invalid email",(){
    //ARRANGE
    String email = 'asdsdffsdfsd';

    //ACT
    String? result = Validator.validateEmail(email);

    //ASSERT
    expect(result, "Please enter a valid email");
  });
}
```

After we see the test fail, we implement the validateEmail as below:

```dart
class Validator{
  static String? validateEmail(String email){
      if(email.isEmpty){
        return "Required field";
      }

      //check for a valid email with a Regular Expression
      const String emailRegexPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9\w-]+\.[a-zA-Z]+";

      RegExp regExp  = RegExp(emailRegexPattern);

      if(regExp.hasMatch(email)){
        return "Please enter a valid email";
      }
  }
}
```

We do similar things for password too. After everything, the code looks like below: 

**validator_test.dart:**
```dart
void main(){
  group("Validator -",(){
    test("validate for empty email",(){
      //ARRANGE
      String email = '';

      //ACT
      String? result = Validator.validateEmail(email);

      //ASSERT
      expect(result, "Required field");
    });

    test("validate for invalid email",(){
      //ARRANGE
      String email = 'sdsdsd';

      //ACT
      String? result = Validator.validateEmail(email);

      //ASSERT
      expect(result, "Please enter a valid email");
    });

    test("validate for valid email",(){
      //ARRANGE
      String email = 'dev.basakk6@gmail.com';

      //ACT
      String? result = Validator.validateEmail(email);

      //ASSERT
      expect(result, null);
    });

    test("validate for empty password",(){
      //ARRANGE
      String password = '';

      //ACT
      String? result = Validator.validatePassword(password);

      //ASSERT
      expect(result, "Required field");
    });

    test("validate for invalid password",(){
      //ARRANGE
      String password = '1234567';

      //ACT
      String? result = Validator.validatePassword(password);

      //ASSERT
      expect(result, "Password should be a minimum of 8 characters");
    });

    test("validate for valid password",(){
      //ARRANGE
      String password = '12345678';

      //ACT
      String? result = Validator.validatePassword(password);

      //ASSERT
      expect(result, null);
    });
  });
}
```

**validator.dart:**

```dart
class Validator{
  static String? validateEmail(String email){
      if(email.isEmpty){
        return "Required field";
      }

      //check for a valid email with a Regular Expression
      const String emailRegexPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9\w-]+\.[a-zA-Z]+";

      RegExp regExp  = RegExp(emailRegexPattern);

      if(!regExp.hasMatch(email)){
        return "Please enter a valid email";
      }
      return null;
  }

  static String? validatePassword(String password){
    if(password.isEmpty){
      return "Required field";
    }

    if(password.length < 8){
      return "Password should be a minimum of 8 characters";
    }

    return null;
  }
}
```

## Flutter Widget Testing

Widget tests in Flutter focus on testing individual widgets in isolation. They ensure that widgets are rendered correctly and that they respond to user interactions as expected. Widget tests work with Flutter's flutter_test package and the flutter_test.WidgetTester class.
Widget tests render Flutter widgets in a test environment but don't require the presence of the full application or any external services. This allows developers to verify that widgets look and behave as intended without the complexity of running the entire app.

## Flutter Integration Testing

Integration tests in Flutter are used to test the interactions between multiple parts of the application as a whole. Unlike unit tests and widget tests, integration tests run the entire application in a simulated environment, including interactions with APIs, databases, and other external services.
Integration tests are more comprehensive and closer to real-world scenarios, ensuring that different components of the application work together correctly. These tests can be more time-consuming than unit and widget tests but provide a higher level of confidence in the overall functionality of the application.

## In Summary

Unit tests focus on testing small, isolated units of code.
Widget tests focus on testing individual widgets in isolation.
Integration tests focus on testing the interactions between multiple components of the application as a whole.