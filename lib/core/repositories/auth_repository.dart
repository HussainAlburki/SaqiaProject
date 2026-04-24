import 'package:saqia/core/models/saqia_models.dart';

abstract class AuthRepository {
  Future<String> signUp({
    required UserRole role,
    required String name,
    required String phone,
    required String email,
    required String password,
  });

  Future<String> signIn({
    required UserRole role,
    required String email,
    required String password,
  });
}
