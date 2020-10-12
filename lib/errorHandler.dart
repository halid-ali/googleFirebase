import 'package:flutter/services.dart';

class ErrorHandler {
  String handleError(PlatformException error) {
    print(error);

    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        return 'The user cannot be found!!!';
      case 'ERROR_WRONG_PASSWORD':
        return 'Wrong password!!!';
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return 'This email is already in use.';
      case 'ERROR_USER_DISABLED':
        return 'The user has been disabled by administrator.';
    }

    return null;
  }
}
