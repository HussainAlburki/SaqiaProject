import 'dart:math';

import 'package:flutter/material.dart';
import 'package:saqia/core/data/mock_data.dart';
import 'package:saqia/core/models/saqia_models.dart';
import 'package:saqia/core/repositories/mock/mock_mosque_repository.dart';
import 'package:saqia/core/repositories/mock/mock_order_repository.dart';
import 'package:saqia/core/repositories/mosque_repository.dart';
import 'package:saqia/core/repositories/order_repository.dart';

class SaqiaState extends ChangeNotifier {
  SaqiaState({
    MosqueRepository? mosqueRepository,
    OrderRepository? orderRepository,
  })  : _mosqueRepository = mosqueRepository ?? MockMosqueRepository(),
        _orderRepository = orderRepository ?? MockOrderRepository() {
    _bootstrap();
  }

  final MosqueRepository _mosqueRepository;
  final OrderRepository _orderRepository;

  UserRole? role;
  String? currentUserName;
  List<DonationOrder> orders = [];
  List<Mosque> mosques = [];
  List<String> uploadedPhotos = [];
  int selectedPackages = 10;
  bool isLoading = false;

  bool get isAuthenticated => role != null;

  Future<void> _bootstrap() async {
    isLoading = true;
    notifyListeners();
    await refreshData();
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshData() async {
    mosques = await _mosqueRepository.getMosques();
    orders = await _orderRepository.getAllOrders();
    notifyListeners();
  }

  void login({required UserRole userRole, required String name}) {
    role = userRole;
    currentUserName = name;
    notifyListeners();
  }

  void logout() {
    role = null;
    currentUserName = null;
    notifyListeners();
  }

  List<DonationOrder> donorOrders() => orders.where((e) => e.donorName == 'Amina Khan' || e.donorName == currentUserName).toList();
  List<DonationOrder> supplierOrders() => orders.where((e) => e.supplierName == 'Saif Logistics').toList();

  Mosque? mosqueById(String id) {
    for (final mosque in mosques) {
      if (mosque.id == id) return mosque;
    }
    return null;
  }

  DonationOrder? byId(String id) {
    for (final order in orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  DonationOrder createDonation(Mosque mosque) {
    final id = 'SQ-${10000 + Random().nextInt(89999)}';
    final order = DonationOrder(
      id: id,
      donorName: currentUserName ?? 'Donor',
      supplierName: 'Saif Logistics',
      mosque: mosque,
      warehouse: mainWarehouse,
      packages: selectedPackages,
      status: OrderStatus.pending,
      priority: selectedPackages > 30 ? PriorityLevel.urgent : PriorityLevel.normal,
      totalAmount: selectedPackages * 5,
    );
    orders = [order, ...orders];
    _orderRepository.createOrder(order);
    notifyListeners();
    return order;
  }

  void updateProof(String id, List<String> photos, String? notes) {
    uploadedPhotos = photos;
    orders = orders
        .map((e) => e.id == id
            ? DonationOrder(
                id: e.id,
                donorName: e.donorName,
                supplierName: e.supplierName,
                mosque: e.mosque,
                warehouse: e.warehouse,
                packages: e.packages,
                status: OrderStatus.completed,
                priority: e.priority,
                totalAmount: e.totalAmount,
                proof: DeliveryProof(photos: photos, notes: notes),
              )
            : e)
        .toList();
    _orderRepository.attachDeliveryProof(orderId: id, photos: photos, notes: notes);
    notifyListeners();
  }
}
