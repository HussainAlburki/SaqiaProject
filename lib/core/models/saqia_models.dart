enum UserRole { donor, supplier, admin }

enum OrderStatus { pending, inProgress, completed }

enum PriorityLevel { urgent, high, normal }

class Mosque {
  const Mosque({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.stockLevel,
    required this.prayerTimes,
    required this.address,
  });

  final String id;
  final String name;
  final double distanceKm;
  final int stockLevel;
  final Map<String, String> prayerTimes;
  final String address;
}

class Warehouse {
  const Warehouse({
    required this.name,
    required this.address,
    required this.phone,
    required this.distanceKm,
  });

  final String name;
  final String address;
  final String phone;
  final double distanceKm;
}

class DeliveryProof {
  const DeliveryProof({
    required this.photos,
    this.videoUrl,
    this.notes,
  });

  final List<String> photos;
  final String? videoUrl;
  final String? notes;
}

class DonationOrder {
  const DonationOrder({
    required this.id,
    required this.donorName,
    required this.supplierName,
    required this.mosque,
    required this.warehouse,
    required this.packages,
    required this.status,
    required this.priority,
    required this.totalAmount,
    this.proof,
  });

  final String id;
  final String donorName;
  final String supplierName;
  final Mosque mosque;
  final Warehouse warehouse;
  final int packages;
  final OrderStatus status;
  final PriorityLevel priority;
  final double totalAmount;
  final DeliveryProof? proof;
}
