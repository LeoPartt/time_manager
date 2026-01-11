import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_credentials.freezed.dart';
part 'account_credentials.g.dart';

@freezed
abstract class AccountCredentials with _$AccountCredentials {
  const factory AccountCredentials({
    required String username,
    required String password,
  }) = _AccountCredentials;

  factory AccountCredentials.fromJson(Map<String, dynamic> json) =>
      _$AccountCredentialsFromJson(json);
}
