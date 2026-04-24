import 'package:saqia/core/data/mock_data.dart';
import 'package:saqia/core/models/saqia_models.dart';
import 'package:saqia/core/repositories/mosque_repository.dart';

class MockMosqueRepository implements MosqueRepository {
  @override
  Future<List<Mosque>> getMosques() async {
    return List<Mosque>.from(mosques);
  }

  @override
  Future<Mosque?> getMosqueById(String id) async {
    try {
      return mosques.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
