class Validator {
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    if (value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter valild email id!!!';
    }

    return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty || value.length < 7) {
      return 'Password must be at least 7 characters!!!';
    }

    return null;
  }

  String validateConfirmPassword(String password, String confirmPassword) {
    if (password.trim() != confirmPassword.trim()) {
      return 'Password mismatch!!!';
    }

    return null;
  }
}
