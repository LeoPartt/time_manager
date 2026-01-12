

import 'package:time_manager/domain/repositories/account_repository.dart';

class ChangePassword {
  final AccountRepository repository;

  ChangePassword(this.repository);

  Future<void> call({
    required String code,
    required String password,
  }) async {
    return await repository.changePassword(
      code: code,
      password: password,
    );
  }
}