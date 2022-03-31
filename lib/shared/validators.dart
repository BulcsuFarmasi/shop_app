class Validators {
  static bool required(String? value) {
    return value == null || value.isEmpty;
  }

  static bool minLength(String? value, int minLength) {
    return value != null && value.length < minLength;
  }

  static bool maxLength(String? value, int maxLength) {
    return value != null && value.length > maxLength;
  }

  static bool isNumber(String? value) {
    return value != null && num.tryParse(value) == null;
  }

  static bool minNumber(String? value, int min) {
    return value != null && num.parse(value) <= min;
  }

  static bool pattern(String? value, RegExp pattern) {
    return value != null && !pattern.hasMatch(value);
  }

  static bool url(String? value) {
    return pattern(
            value, RegExp(r'(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:,.;]*)?'));
  }

  static bool email(String? value) {
    return pattern(value, RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
  }
}
