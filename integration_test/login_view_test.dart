import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test_driven_development/login_view.dart';

void main() {
  group("Login Flow Integration Test -", () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    //test for the success scenario
    testWidgets(
        "Should show the HomeView when the user enters valid email & password and taps the login button",
        (widgetTester) async {
      //ARRANGE

      //load the widget (this method returns a future so we should use await/async)
      //wrap your desired widget with MaterialApp to have material design principles
      await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

      //ACT

      //first, find the TextFormField widgets and set valid texts
      Finder emailTextFormField =
          find.byKey(const ValueKey("email_text_form_field"));
      Finder passwordTextFormField =
          find.byKey(const ValueKey("password_text_form_field"));

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
      Finder passwordErrorText =
          find.text("Password should be a minimum of 8 characters");
      Finder homeViewTitle = find.text("Home Screen");

      //ASSERT

      //there shouldn't be any error message and the route should change to HomeView
      expect(emptyFieldErrorText, findsNothing);
      expect(emailErrorText, findsNothing);
      expect(passwordErrorText, findsNothing);
      expect(homeViewTitle, findsOneWidget);
    });
  });

  //error cases

  // test for the error case 1 -> empty input
  testWidgets(
      "Should show 'Required field' message if email & password is empty",
      (widgetTester) async {
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

  // test for the error case 2 -> invalid email
  testWidgets(
      "Should show 'Please enter a valid email' message if the entered email is in invalid format",
      (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT
    //first, enter an invalid text to email TextFormField
    Finder emailTextFormField =
        find.byKey(const ValueKey("email_text_form_field"));
    await widgetTester.enterText(emailTextFormField, "invalid email example");

    //second, find the login button and simulate the press action by tap()
    Finder loginButton = find.byType(ElevatedButton);
    await widgetTester.tap(loginButton);
    //wait for the rendering complete after the action
    await widgetTester.pumpAndSettle();

    //find the required text after the action completed
    Finder errorText = find.text("Please enter a valid email");

    //ASSERT
    //there should be exactly 2 because we haven't provided input text for the TextFormFields
    expect(errorText, findsOneWidget);
  });

  // test for the error case 3 -> invalid password
  testWidgets(
      "Should show 'Password should be a minimum of 8 characters' if the entered password is less than 8 characters",
      (widgetTester) async {
    //ARRANGE

    //load the widget (this method returns a future so we should use await/async)
    //wrap your desired widget with MaterialApp to have material design principles
    await widgetTester.pumpWidget(const MaterialApp(home: LoginView()));

    //ACT

    //first, enter an invalid text to email TextFormField
    Finder passwordTextFormField =
        find.byKey(const ValueKey("password_text_form_field"));
    await widgetTester.enterText(passwordTextFormField, "12345");

    //second, find the login button and simulate the press action by tap()
    Finder loginButton = find.byType(ElevatedButton);
    await widgetTester.tap(loginButton);
    //wait for the rendering complete after the action
    await widgetTester.pumpAndSettle();

    //find the required text after the action completed
    Finder errorText =
        find.text("Password should be a minimum of 8 characters");

    //ASSERT

    expect(errorText, findsOneWidget);
  });
}
