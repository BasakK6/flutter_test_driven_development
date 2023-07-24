class Validator {
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Required field";
    }

    //check for a valid email with a Regular Expression
    const String emailRegexPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9\w-]+\.[a-zA-Z]+";

    RegExp regExp = RegExp(emailRegexPattern);

    if (!regExp.hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Required field";
    }

    if (password.length < 8) {
      return "Password should be a minimum of 8 characters";
    }

    return null;
  }
}
