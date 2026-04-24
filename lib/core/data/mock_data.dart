import 'package:saqia/core/models/saqia_models.dart';

const mosques = <Mosque>[
  Mosque(
    id: 'm1',
    name: 'Al Noor Mosque',
    distanceKm: 1.2,
    stockLevel: 12,
    address: '12 Palm Street',
    prayerTimes: {'Fajr': '5:04', 'Dhuhr': '12:18', 'Asr': '3:42', 'Maghrib': '6:21', 'Isha': '7:44'},
  ),
  Mosque(
    id: 'm2',
    name: 'Masjid Al Rahma',
    distanceKm: 2.0,
    stockLevel: 8,
    address: '89 Green Crescent',
    prayerTimes: {'Fajr': '5:06', 'Dhuhr': '12:19', 'Asr': '3:43', 'Maghrib': '6:22', 'Isha': '7:45'},
  ),
  Mosque(
    id: 'm3',
    name: 'Grand Unity Mosque',
    distanceKm: 3.4,
    stockLevel: 37,
    address: '44 Unity Road',
    prayerTimes: {'Fajr': '5:03', 'Dhuhr': '12:17', 'Asr': '3:40', 'Maghrib': '6:20', 'Isha': '7:43'},
  ),
  Mosque(
    id: 'm4',
    name: 'Al Huda Center',
    distanceKm: 4.5,
    stockLevel: 11,
    address: '7 Huda Avenue',
    prayerTimes: {'Fajr': '5:07', 'Dhuhr': '12:20', 'Asr': '3:44', 'Maghrib': '6:23', 'Isha': '7:46'},
  ),
  Mosque(
    id: 'm5',
    name: 'City Light Mosque',
    distanceKm: 5.1,
    stockLevel: 28,
    address: '101 Light Blvd',
    prayerTimes: {'Fajr': '5:05', 'Dhuhr': '12:18', 'Asr': '3:41', 'Maghrib': '6:21', 'Isha': '7:44'},
  ),
  Mosque(
    id: 'm6',
    name: 'Masjid Al Salam',
    distanceKm: 6.0,
    stockLevel: 6,
    address: '66 Harmony Drive',
    prayerTimes: {'Fajr': '5:08', 'Dhuhr': '12:21', 'Asr': '3:45', 'Maghrib': '6:24', 'Isha': '7:47'},
  ),
];

const mainWarehouse = Warehouse(
  name: 'Central Warehouse',
  address: '25 Logistics Park',
  phone: '+1 555 0102',
  distanceKm: 1.6,
);

final sampleOrders = <DonationOrder>[
  DonationOrder(
    id: 'SQ-10245',
    donorName: 'Amina Khan',
    supplierName: 'Saif Logistics',
    mosque: mosques[0],
    warehouse: mainWarehouse,
    packages: 20,
    status: OrderStatus.pending,
    priority: PriorityLevel.urgent,
    totalAmount: 100,
  ),
  DonationOrder(
    id: 'SQ-10246',
    donorName: 'Ibrahim Noor',
    supplierName: 'Saif Logistics',
    mosque: mosques[1],
    warehouse: mainWarehouse,
    packages: 12,
    status: OrderStatus.inProgress,
    priority: PriorityLevel.high,
    totalAmount: 60,
  ),
  DonationOrder(
    id: 'SQ-10247',
    donorName: 'Layla Omar',
    supplierName: 'Nahr Deliveries',
    mosque: mosques[5],
    warehouse: mainWarehouse,
    packages: 35,
    status: OrderStatus.completed,
    priority: PriorityLevel.normal,
    totalAmount: 175,
    proof: DeliveryProof(
      photos: [
        'https://images.unsplash.com/photo-1524777313-9f4e9855524c',
        'https://images.unsplash.com/photo-1523475472560-d2df97ec485c',
      ],
      notes: 'Delivered after Asr prayer.',
    ),
  ),
];
