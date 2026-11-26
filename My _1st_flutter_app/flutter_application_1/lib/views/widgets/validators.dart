String? requiredField(String? value, String label) {
  if (value == null || value.trim().isEmpty) return 'Please enter $label';
  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Please enter Email Address';
  final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!pattern.hasMatch(value.trim())) return 'Please enter a valid email address';
  return null;
}

String? yearValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'Please enter Year Level';
  final year = int.tryParse(value.trim());
  if (year == null || year < 1 || year > 4) {
    return 'Year Level must be between 1 and 4';
  }
  return null;
}

String? optionalInt(String? value, {int min = 1, int max = 120, String label = 'Value'}) {
  if (value == null || value.trim().isEmpty) return null;
  final n = int.tryParse(value.trim());
  if (n == null || n < min || n > max) return '$label must be $min-$max';
  return null;
}

String? optionalDouble(String? value, {String label = 'Value'}) {
  if (value == null || value.trim().isEmpty) return null;
  final n = double.tryParse(value.trim());
  if (n == null || n <= 0) return '$label must be a positive number';
  return null;
}

String? optionalPhone(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  if (!RegExp(r'^[0-9+\-\s()]{7,30}$').hasMatch(value.trim())) {
    return 'Enter a valid phone number';
  }
  return null;
}
