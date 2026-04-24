import 'dart:math';

import 'package:flutter/material.dart';
import 'package:saqia/core/data/mock_data.dart';
import 'package:saqia/core/models/saqia_models.dart';

class SaqiaState extends ChangeNotifier {
  UserRole? role;
  String? currentUserName;
  List<DonationOrder> orders = List.of(sampleOrders);
  List<String> uploadedPhotos = [];
  int selectedPackages = 10;

  bool get isAuthenticated => role != null;

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
    notifyListeners();
  }
}
