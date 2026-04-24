import 'package:saqia/core/models/saqia_models.dart';

abstract class MosqueRepository {
  Future<List<Mosque>> getMosques();
  Future<Mosque?> getMosqueById(String id);
}
