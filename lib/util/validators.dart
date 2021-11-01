// import 'package:email_validator/email_validator.dart';

class Validators {
  // static bool emailValidator(String email){
  //  return EmailValidator.validate(email);
  // }

  static bool stringLengthValidator(String value, {int length = 0}) {
    return value.trim().length == length;
  }
}
