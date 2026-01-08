import 'package:flutter/material.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'app_exception.dart';

class NetworkException extends AppException {
  final int? statusCode;

  NetworkException(super.message, {this.statusCode, super.details});

  factory NetworkException.fromStatusCode(BuildContext context, int? code) {
    final tr = AppLocalizations.of(context)!;

    switch (code) {
      case 400:
        return NetworkException(tr.badRequest, statusCode: code);
      case 401:
        return NetworkException(tr.unauthorized, statusCode: code);
      case 404:
        return NetworkException(tr.notFound, statusCode: code);
      case 500:
        return NetworkException(tr.serverError, statusCode: code);
      default:
        return NetworkException(tr.networkError(code ?? 0), statusCode: code);
    }
  }

  @override
  String toString() => 'NetworkException($statusCode): $message';
}
