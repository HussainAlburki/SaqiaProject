import 'package:saqia/core/data/mock_data.dart';
import 'package:saqia/core/models/saqia_models.dart';
import 'package:saqia/core/repositories/order_repository.dart';

class MockOrderRepository implements OrderRepository {
  final List<DonationOrder> _orders = List.of(sampleOrders);

  @override
  Future<void> attachDeliveryProof({
    required String orderId,
    required List<String> photos,
    String? notes,
    String? videoUrl,
  }) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index < 0) return;

    final existing = _orders[index];
    _orders[index] = DonationOrder(
      id: existing.id,
      donorName: existing.donorName,
      supplierName: existing.supplierName,
      mosque: existing.mosque,
      warehouse: existing.warehouse,
      packages: existing.packages,
      status: OrderStatus.completed,
      priority: existing.priority,
      totalAmount: existing.totalAmount,
      proof: DeliveryProof(photos: photos, notes: notes, videoUrl: videoUrl),
    );
  }

  @override
  Future<DonationOrder> createOrder(DonationOrder order) async {
    _orders.insert(0, order);
    return order;
  }

  @override
  Future<List<DonationOrder>> getAllOrders() async {
    return List<DonationOrder>.from(_orders);
  }

  @override
  Future<DonationOrder?> getOrderById(String id) async {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
