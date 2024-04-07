validEmail(String email) {
  if (email.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
    return 'Please enter a valid email';
  }
  return null;
}

validPassword(String password) {
  if (password.isEmpty) {
    return 'Password is required';
  }
  if (password.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

validName(String name) {
  if (name.isEmpty) {
    return 'Name is required';
  }
  return null;
}

validPhone(String phone) {
  if (phone.isEmpty) {
    return 'Phone is required';
  }

  if (phone.length != 8) {
    return 'Phone number must be 8 digits';
  }
  return null;
}

validConfirmPassword(String password, String confirmPassword) {
  if (confirmPassword.isEmpty) {
    return 'Confirm password is required';
  }
  if (password != confirmPassword) {
    return 'Password does not match';
  }
  return null;
}
