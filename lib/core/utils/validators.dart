class Validators {
  static String? name(String value) {
    if (value.trim().isEmpty) return "Name is required";
    if (value.length < 3) return "Enter at least 3 characters";
    return null;
  }

  static String? email(String value) {
    if (value.trim().isEmpty) return "Email is required";
    if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.[A-Za-z]+').hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6) return "At least 6 characters required";
    return null;
  }
}
