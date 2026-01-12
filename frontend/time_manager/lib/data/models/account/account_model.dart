import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_model.freezed.dart';
part 'account_model.g.dart';

@freezed
abstract class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String token,

    /// Correspond à "expiresIn" dans la réponse JSON du backend
    num? expiresIn,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}

