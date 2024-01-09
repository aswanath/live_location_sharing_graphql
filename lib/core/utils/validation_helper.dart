class Validator {
  static bool validEmail(String? value) {
    bool isValid = true;
    if (value == null || value.isEmpty || value.length < 5) {
      isValid = false;
    } else if (!RegExp(r"^[a-zA-Z\d.a-zA-Z!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+").hasMatch(value)) {
      isValid = false;
    }
    return isValid;
  }

  static bool validMobileNumber(String? value) {
    if ((value?.isEmpty ?? false) || value?.length != 10) {
      return false;
    } else {
      return true;
    }
  }

  static bool validField(String? value) {
    return value != null && value.isNotEmpty;
  }
}
