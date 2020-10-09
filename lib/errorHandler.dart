import 'package:flutter/services.dart';

class ErrorHandler {
  String handleError(PlatformException error) {
    print(error);

    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        return 'User not found!!!';
      case 'ERROR_WRONG_PASSWORD':
        return 'Wrong password!!!';
    }

    return null;
  }
}
