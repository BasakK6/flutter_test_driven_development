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

## What will we create?

Below is the screen recording of the finished app (we will create this app with TDD approach by using unit, widget and integration tests. We will also use mockito package to mock the API request): 

<img src="https://github.com/BasakK6/flutter_test_driven_development/blob/master/readme_assets/android_screen_recording.gif?raw=true" alt="UI screen recording" width="250"/>

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

### USE CASE: Login Screen

Let's say we want a screen with email and password textfields and a button that validates them. If the validation succeeds we go to another route in our application (for example to home screen). If it fails we show the related messages in the text fields. We already finished the validation logic. So we should start creating the screen by using a TDD approach too.

Right now our **login_view.dart** file looks like this:

```dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```

We then create **login_view_test.dart** file under the test folder. This time we will use **testWidgets()** function instead of **test()**:

STEPS:
1) load the widget with pumpWidget (you should await this method call and you can use MaterialApp that wraps your desired widget)
2) find your desired with its **text** or other options such as **byKey**, **byType**. (The most recommended way is byKey)
3) use expect(finder, matcher) -> here the matcher can be options like findsOneWidget, findsNothing, findsNWidget(n)

```dart
void main(){
  testWidgets("Should have a title", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //check if the title is there or not
    Finder title = find.text("Login Screen");

    //ASSERT
    expect(title, findsOneWidget);
  });
}
```

When we run the test, it will fail. So we add the required widget that has a "Login Screen" text.

```dart
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Screen"),),
    );
  }
}
```

Next, we test to find necessary TextFormFields by their Key:

```dart
void main(){
  testWidgets("Should have a title", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //check if the title is there or not
    Finder title = find.text("Login Screen");

    //ASSERT
    expect(title, findsOneWidget);
  });
  
  testWidgets("Should have one TextFormField to collect user email", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //check if the email TextFormField is there or not
    Finder emailTextFormField = find.byKey(const ValueKey("email_text_form_field"));

    //ASSERT
    expect(emailTextFormField, findsOneWidget);
  });

  testWidgets("Should have one TextFormField to collect user password", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //check if the password TextFormField is there or not
    Finder passwordTextFormField = find.byKey(const ValueKey("password_text_form_field"));

    //ASSERT
    expect(passwordTextFormField, findsOneWidget);
  });
}
```

After that, we create the widgets to make the test pass:

```dart
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                key: const ValueKey("email_text_form_field"),
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText:"Email",
                ),
              ),
              TextFormField(
                key: const ValueKey("password_text_form_field"),
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText:"Password",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Lastly, we test to find one ElevatedButton for login button. We test to find byType:

```dart
void main(){
  testWidgets("Should have a title", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //check if the title is there or not
    Finder title = find.text("Login Screen");

    //ASSERT
    expect(title, findsOneWidget);
  });

  testWidgets("Should have one TextFormField to collect user email", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //check if the email TextFormField is there or not
    Finder emailTextFormField = find.byKey(const ValueKey("email_text_form_field"));

    //ASSERT
    expect(emailTextFormField, findsOneWidget);
  });

  testWidgets("Should have one TextFormField to collect user password", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //check if the password TextFormField is there or not
    Finder passwordTextFormField = find.byKey(const ValueKey("password_text_form_field"));

    //ASSERT
    expect(passwordTextFormField, findsOneWidget);
  });

  testWidgets("Should have one login button", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //check if the login Button is there or not
    Finder loginButton = find.byType(ElevatedButton);

    //ASSERT
    expect(loginButton, findsOneWidget);
  });
}
```

LoginView after we added the button:

```dart
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                key: const ValueKey("email_text_form_field"),
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText:"Email",
                ),
              ),
              TextFormField(
                key: const ValueKey("password_text_form_field"),
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText:"Password",
                ),
              ),
              const SizedBox(height: 16,),
              ElevatedButton(onPressed: (){}, child: const Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}
```

### USE CASE: Login Screen (test the validation logic with widgets)

After creating the required widgets, we can test if we can add the validation logic properly:

```dart
void main(){
  testWidgets("Should show 'Required field' message if email & password is empty", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //first find the login button and simulate the press action by tap()
    Finder loginButton = find.byType(ElevatedButton);
    await widgetTester.tap(loginButton);
    //wait for the rendering complete after the action
    await widgetTester.pumpAndSettle();

    //find the required text after the action completed
    Finder requiredFieldText = find.text("Required field");

    //ASSERT
    //there should be exactly 2 because we haven't provided input text for the TextFormFields
    expect(requiredFieldText, findsNWidgets(2));
  });
}
```

Then, we update the widget like so:

(we implement the form validation)

```dart
import 'package:flutter/material.dart';
import 'package:test_driven_development/validator.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: const ValueKey("email_text_form_field"),
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                  validator: (value) => Validator.validatePassword(value ?? ""),
                ),
                TextFormField(
                    key: const ValueKey("password_text_form_field"),
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    validator:(value) => Validator.validatePassword(value ?? ""),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState?.validate();
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

We can also test for the invalid inputs:

```dart
void main(){
  // test for the error case 2 -> invalid email
  testWidgets("Should show 'Please enter a valid email' message if the entered email is in invalid format", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT
    //first, enter an invalid text to email TextFormField
    Finder emailTextFormField = find.byKey(const ValueKey("email_text_form_field"));
    await widgetTester.enterText(emailTextFormField, "invalid email example");

    //second, find the login button and simulate the press action by tap()
    Finder loginButton = find.byType(ElevatedButton);
    await widgetTester.tap(loginButton);
    //wait for the rendering complete after the action
    await widgetTester.pumpAndSettle();

    //find the required text after the action completed
    Finder errorText = find.text("Please enter a valid email");

    //ASSERT
    expect(errorText, findsOneWidget);
  });

  // test for the error case 3 -> invalid password
  testWidgets("Should show 'Password should be a minimum of 8 characters' if the entered password is less than 8 characters", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //first, enter an invalid text to password TextFormField
    Finder passwordTextFormField = find.byKey(const ValueKey("password_text_form_field"));
    await widgetTester.enterText(passwordTextFormField, "12345");

    //second, find the login button and simulate the press action by tap()
    Finder loginButton = find.byType(ElevatedButton);
    await widgetTester.tap(loginButton);
    //wait for the rendering complete after the action
    await widgetTester.pumpAndSettle();

    //find the required text after the action completed
    Finder errorText = find.text("Password should be a minimum of 8 characters");

    //ASSERT
    expect(errorText, findsOneWidget);
  });
}
```

Lastly, let's test for the success scenario:

(when the user enters valid email & password, they should not see any error message and the screen should change to HomeView)
(of course, in the reality, we would test the login credentials with a service such as REST API)

```dart
void main(){
  testWidgets("Should show the HomeView when the user enters valid email & password and taps the login button", (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //first, find the TextFormField widgets and set valid texts
    Finder emailTextFormField = find.byKey(const ValueKey("email_text_form_field"));
    Finder passwordTextFormField = find.byKey(const ValueKey("password_text_form_field"));

    await widgetTester.enterText(emailTextFormField, "dev.basakk6@gmail.com");
    await widgetTester.enterText(passwordTextFormField, "12345678");

    //second, find the login button and simulate the press action by tap()
    Finder loginButton = find.byType(ElevatedButton);
    await widgetTester.tap(loginButton);
    //wait for the rendering complete after the action
    await widgetTester.pumpAndSettle();

    //find the required text after the action completed
    Finder emptyFieldErrorText = find.text("Required field");
    Finder emailErrorText = find.text("Please enter a valid email");
    Finder passwordErrorText = find.text("Password should be a minimum of 8 characters");
    Finder homeViewTitle = find.text("Home Screen");
    
    //ASSERT

    //there shouldn't be any error message and the route should change to HomeView
    expect(emptyFieldErrorText, findsNothing);
    expect(emailErrorText, findsNothing);
    expect(passwordErrorText, findsNothing);
    expect(homeViewTitle, findsOneWidget);
  });
}
```

The final version of the LoginView is:

```dart
import 'package:flutter/material.dart';
import 'package:test_driven_development/home_view.dart';
import 'package:test_driven_development/validator.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: const ValueKey("email_text_form_field"),
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                  validator: (value) => Validator.validateEmail(value ?? ""),
                ),
                TextFormField(
                    key: const ValueKey("password_text_form_field"),
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    validator: (value) => Validator.validatePassword(value ?? "")),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState?.validate() ?? false){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomeView()));
                    }
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

And the HomeView is:

```dart
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen"),),
      body: Container(),
    );
  }
}
```

## Flutter Integration Testing

Integration tests in Flutter are used to test the interactions between multiple parts of the application as a whole. Unlike unit tests and widget tests, integration tests run the entire application in a simulated environment, including interactions with APIs, databases, and other external services.
Integration tests are more comprehensive and closer to real-world scenarios, ensuring that different components of the application work together correctly. These tests can be more time-consuming than unit and widget tests but provide a higher level of confidence in the overall functionality of the application.

We should code the tests similar to widget testing. However, we must use this line of code before all the testWidget() calls if we want to run the tests in an emulator.

```dart
void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
}
```

Success scenario:

```dart
void main(){
  group("Login Flow Integration Test -", (){
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    //test for the success scenario
    testWidgets("Should show the HomeView when the user enters valid email & password and taps the login button", (widgetTester) async {
      //ARRANGE

      //load the widget (this method returns a future so we should use await/async)
      //wrap your desired widget with MaterialApp to have material design principles
      await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

      //ACT

      //first, find the TextFormField widgets and set valid texts
      Finder emailTextFormField = find.byKey(const ValueKey("email_text_form_field"));
      Finder passwordTextFormField = find.byKey(const ValueKey("password_text_form_field"));

      await widgetTester.enterText(emailTextFormField, "dev.basakk6@gmail.com");
      await widgetTester.enterText(passwordTextFormField, "12345678");

      //second, find the login button and simulate the press action by tap()
      Finder loginButton = find.byType(ElevatedButton);
      await widgetTester.tap(loginButton);
      //wait for the rendering complete after the action
      await widgetTester.pumpAndSettle();

      //find the required text after the action completed
      Finder emptyFieldErrorText = find.text("Required field");
      Finder emailErrorText = find.text("Please enter a valid email");
      Finder passwordErrorText = find.text("Password should be a minimum of 8 characters");
      Finder homeViewTitle = find.text("Home Screen");

      //ASSERT

      //there shouldn't be any error message and the route should change to HomeView
      expect(emptyFieldErrorText, findsNothing);
      expect(emailErrorText, findsNothing);
      expect(passwordErrorText, findsNothing);
      expect(homeViewTitle, findsOneWidget);
    });
  });
}
```

We can add the other widget tests for the error case. You can find the complete code under **integration_test** folder.

## Using Mocks in Unit Testing (with mockito package)

Unit tests do not interact with external dependencies like databases, network services, or user interfaces. Instead, they mock or stub these dependencies to focus solely on testing the logic within the unit being tested.

### USE CASE: Posts List 

We want to retrieve the posts data from the "https://jsonplaceholder.typicode.com/comments" API end point and show the posts with a ListView inside the Home Screen.

NOTE: Udemy course uses a REST API related to book data and **http** library instead of **Dio** package for the REST API call. I wanted to use Dio with Mockito package.

Before writing code we should import necessary packages:

```yaml
dependencies:
  #network requests
  dio: ^5.3.0

dev_dependencies:
  #test related mocks
  mockito: ^5.4.0
  #code generation
  build_runner: ^2.3.3
```

First we should create a service class that receives the Dio instance from its constructor. This dependency injection is important for writing testable code. 

```dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:test_driven_development/features/home/model/post.dart';

class PostsService {
  final Dio _dio;
  final _apiUrl = "https://jsonplaceholder.typicode.com/comments";

  PostsService(this._dio);

  Future<List<Post>> fetchData() async {
    //TODO: use _dio instance to get data from _apiURL
    return [];
  }
}
```

Then we write the SUCCESS and FAILURE test cases inside the posts:.

post_service_test.dart:
```dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_driven_development/features/home/model/post.dart';
import 'package:test_driven_development/features/home/service/post_service.dart';

import 'post_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  group("Posts Service Tests -", () {
    //Success Scenario
    test("Should return list of post data if the Post Service can fetch posts", () async {
      //ARRANGE
      const apiUrl = "https://jsonplaceholder.typicode.com/comments";
      final responseStub = [
        {
          "postId": 1,
          "id": 1,
          "name": "id labore ex et quam laborum",
          "email": "Eliseo@gardner.biz",
          "body":
              "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
        },
        {
          "postId": 1,
          "id": 2,
          "name": "quo vero reiciendis velit similique earum",
          "email": "Jayne_Kuhic@sydney.com",
          "body":
              "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et"
        },
      ];
      final mockDio = MockDio();
      when(mockDio.get(apiUrl)).thenAnswer((realInvocation) async => Response(
            data: responseStub,
            requestOptions: RequestOptions(),
            statusCode: HttpStatus.ok,
          ));

      //ACT
      final postsService = PostService(mockDio);
      final result = await postsService.fetchData();

      //ASSERT
      expect(result, isA<List<Post>>());
      expect(result.length, 2);
    });
  });

  //Error Scenario
  test("Should throw an exception if the Post Service can't fetch the posts",
      () async {
    //ARRANGE
    const apiUrl = "https://jsonplaceholder.typicode.com/comments";
    final mockDio = MockDio();
    when(mockDio.get(apiUrl)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(),
          statusCode: HttpStatus.unauthorized,
        ));

    //ACT
    final postsService = PostService(mockDio);
    final result = await postsService.fetchData();

    //ASSERT
    expect(result, throwsException);
  });
}
```

Before writing tests we should use the annotation below in order to generate a mock class for Dio class. Then, we run **flutter pub run build_runner build** command in the terminal. This will create the **post_service_test.mocks.dart** file:

```dart
@GenerateNiceMocks([MockSpec<Dio>()])
```

In the success scenario we create a stub for the Response that will be received when the MockDio's get method is called with the defined API end point. Then, we expect to have a List of Post items that has a length of 2 (since the stub has only 2 items).
In the error scenario we expect to have an Exception thrown since the Response statusCode is not HttpStatus.ok (200).
We run the tests and see them fail. After that we implement the service code:

```dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:test_driven_development/features/home/model/post.dart';

class PostService {
  final Dio _dio;
  final _apiUrl = "https://jsonplaceholder.typicode.com/comments";

  PostService(this._dio);

  Future<List<Post>> fetchData() async {
   final response = await _dio.get(_apiUrl);
    if (response.statusCode == HttpStatus.ok) {
      if (response.data is List) {
        return (response.data as List)
            .map((item) => Post.fromJson(item))
            .toList();
      }
    } else {
      throw (Exception("Couldn't retrieve data"));
    }
    return [];
  }
}
```

Our model class:
```dart
class Post {
  int? postId;
  int? id;
  String? name;
  String? email;
  String? body;

  Post({this.postId, this.id, this.name, this.email, this.body});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    body = json['body'];
  }
}
```

After the implementation, we see the tests passing.

Now we can use this service inside our home screen:

home_view_model.dart:
```dart
import 'package:test_driven_development/features/home/view/home_view.dart';

abstract class HomeViewModel extends State<HomeView>{
  late final PostService _postsService;
  late final Future<List<Post>> postsFuture;

  @override
  void initState() {
    super.initState();
    _postsService = PostService(Dio());
    postsFuture = _postsService.fetchData();
  }
}
```

home_view.dart:
```dart
import 'package:flutter/material.dart';
import 'package:test_driven_development/features/home/model/post.dart';
import 'package:test_driven_development/features/home/view/components/post_card.dart';
import 'package:test_driven_development/features/home/view_model/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends HomeViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: postsFuture,
          builder: (context, asyncSnapshot) {
            switch (asyncSnapshot.connectionState) {
              case ConnectionState.done:
                if (asyncSnapshot.hasError) {
                  return Text(asyncSnapshot.error.toString());
                } else {
                  //asyncSnapshot.hasData
                  return asyncSnapshot.data?.isEmpty ?? false
                      ? const Text("There is no data")
                      : buildPostsListView(asyncSnapshot);
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  ListView buildPostsListView(AsyncSnapshot asyncSnapshot) {
    return ListView.builder(
      itemCount: asyncSnapshot.data?.length,
      itemBuilder: (context, index) {
        return PostCard(post: asyncSnapshot.data?[index]);
      },
    );
  }
}
```

post_card.dart:
```dart
import 'package:flutter/material.dart';
import 'package:test_driven_development/features/home/model/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
  });

  final Post? post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: post == null
            ? const SizedBox.shrink()
            : ListTile(
          leading: Text(post!.id.toString() ?? ""),
          title: Text(post!.name ?? ""),
          subtitle: Text(post!.body ?? ""),
        ),
      ),
    );
  }
}
```

One improvement we can do in our test codes is that we can use **Setup()** and **tearDown()** methods for repeated code. Below is the final version of the test codes:

NOTE: **setUp()** will be called before each test is run, and the **tearDown()** will be called after each the test case is finished.

```dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_driven_development/features/home/model/post.dart';
import 'package:test_driven_development/features/home/service/post_service.dart';

import 'post_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late String apiUrl;
  late MockDio mockDio;

  setUp((){
    mockDio = MockDio();
    apiUrl = "https://jsonplaceholder.typicode.com/comments";
  });

  tearDown(() => (){
    mockDio.close();
  });

  group("Posts Service Tests -", () {
    //Success Scenario
    test("Should return list of post data if the Post Service can fetch posts", () async {
      //ARRANGE
      final responseStub = [
        {
          "postId": 1,
          "id": 1,
          "name": "id labore ex et quam laborum",
          "email": "Eliseo@gardner.biz",
          "body":
          "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
        },
        {
          "postId": 1,
          "id": 2,
          "name": "quo vero reiciendis velit similique earum",
          "email": "Jayne_Kuhic@sydney.com",
          "body":
          "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et"
        },
      ];

      when(mockDio.get(apiUrl)).thenAnswer((realInvocation) async => Response(
        data: responseStub,
        requestOptions: RequestOptions(),
        statusCode: HttpStatus.ok,
      ));

      //ACT
      final postsService = PostService(mockDio);
      final result = await postsService.fetchData();

      //ASSERT
      expect(result, isA<List<Post>>());
      expect(result.length, 2);
    });
  });

  //Error Scenario
  test("Should throw an exception if the Post Service can't fetch the posts",
          () async {
        //ARRANGE
        when(mockDio.get(apiUrl)).thenAnswer((realInvocation) async => Response(
          requestOptions: RequestOptions(),
          statusCode: HttpStatus.unauthorized,
        ));

        //ACT
        final postsService = PostService(mockDio);

        try{
          final result = await postsService.fetchData();
          //ASSERT
          expect(result, throwsException);
        }
        catch(e){
          if (kDebugMode) {
            print("Exception caught");
          }
        }
      });
}
```

## In Summary

Unit tests focus on testing small, isolated units of code.
Widget tests focus on testing individual widgets in isolation.
Integration tests focus on testing the interactions between multiple components of the application as a whole.