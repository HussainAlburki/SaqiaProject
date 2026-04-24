import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saqia/core/models/saqia_models.dart';
import 'package:saqia/core/state/saqia_state.dart';
import 'package:saqia/core/widgets/ui.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  OrderStatus? filter;

  @override
  Widget build(BuildContext context) {
    final all = context.watch<SaqiaState>().orders;
    final items = filter == null ? all : all.where((o) => o.status == filter).toList();
    final revenue = all.fold<double>(0, (sum, o) => sum + o.totalAmount);
    final packages = all.fold<int>(0, (sum, o) => sum + o.packages);
    final active = all.where((o) => o.status != OrderStatus.completed).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const GradientHeader(title: 'Operations Overview'),
        const SizedBox(height: 10),
        Text('Revenue: \$${revenue.toStringAsFixed(0)} • Packages: $packages • Active: $active'),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(label: const Text('All'), selected: filter == null, onSelected: (_) => setState(() => filter = null)),
            FilterChip(label: const Text('Pending'), selected: filter == OrderStatus.pending, onSelected: (_) => setState(() => filter = OrderStatus.pending)),
            FilterChip(label: const Text('In Progress'), selected: filter == OrderStatus.inProgress, onSelected: (_) => setState(() => filter = OrderStatus.inProgress)),
            FilterChip(label: const Text('Completed'), selected: filter == OrderStatus.completed, onSelected: (_) => setState(() => filter = OrderStatus.completed)),
          ],
        ),
        const SizedBox(height: 10),
        ...items.map(
          (o) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${o.id} • ${o.mosque.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Donor: ${o.donorName} | Supplier: ${o.supplierName}'),
                Text('Warehouse: ${o.warehouse.name}'),
                Row(children: [StatusChip(status: o.status), const SizedBox(width: 8), PriorityChip(level: o.priority)]),
                Text('Proof uploads: ${o.proof?.photos.length ?? 0} photos'),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
