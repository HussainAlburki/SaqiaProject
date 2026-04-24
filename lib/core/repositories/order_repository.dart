import 'package:saqia/core/models/saqia_models.dart';

abstract class OrderRepository {
  Future<List<DonationOrder>> getAllOrders();
  Future<DonationOrder?> getOrderById(String id);
  Future<DonationOrder> createOrder(DonationOrder order);
  Future<void> attachDeliveryProof({
    required String orderId,
    required List<String> photos,
    String? notes,
    String? videoUrl,
  });
}
