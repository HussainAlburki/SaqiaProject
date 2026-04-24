import 'package:saqia/core/models/saqia_models.dart';
import 'package:saqia/core/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<String> signIn({
    required UserRole role,
    required String email,
    required String password,
  }) async {
    return email.split('@').first;
  }

  @override
  Future<String> signUp({
    required UserRole role,
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    return name;
  }
}
