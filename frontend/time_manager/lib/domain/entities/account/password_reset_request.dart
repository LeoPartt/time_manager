class PasswordResetRequest {
  final String code;
  final String password;

  const PasswordResetRequest({
    required this.code,
    required this.password,
  });
}