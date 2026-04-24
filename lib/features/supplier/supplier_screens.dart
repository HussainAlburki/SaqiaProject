import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saqia/core/models/saqia_models.dart';
import 'package:saqia/core/state/saqia_state.dart';
import 'package:saqia/core/theme/app_theme.dart';
import 'package:saqia/core/widgets/ui.dart';

class SupplierScaffold extends StatelessWidget {
  const SupplierScaffold({super.key, required this.child, required this.index});
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(i == 0 ? '/supplier/home' : '/supplier/profile'),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class SupplierHomeScreen extends StatelessWidget {
  const SupplierHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = context.watch<SaqiaState>().supplierOrders();
    final pending = orders.where((e) => e.status == OrderStatus.pending).length;
    final inProgress = orders.where((e) => e.status == OrderStatus.inProgress).length;
    final completed = orders.where((e) => e.status == OrderStatus.completed).length;
    return SupplierScaffold(
      index: 0,
      child: ListView(padding: const EdgeInsets.all(16), children: [
        const GradientHeader(title: 'Supplier Tasks', subtitle: 'Prioritized deliveries'),
        const SizedBox(height: 12),
        Text('Pending: $pending • In Progress: $inProgress • Completed: $completed'),
        const SizedBox(height: 12),
        ...orders
            .map(
              (o) => Card(
                child: ListTile(
                  onTap: () => context.push('/supplier/order/${o.id}'),
                  title: Text('${o.id} • ${o.mosque.name}'),
                  subtitle: Text('${o.packages} packages'),
                  trailing: PriorityChip(level: o.priority),
                ),
              ),
            ),
      ]),
    );
  }
}

class SupplierOrderDetailsScreen extends StatelessWidget {
  const SupplierOrderDetailsScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final order = context.watch<SaqiaState>().byId(id)!;
    return Scaffold(
      appBar: AppBar(title: Text('Order ${order.id}')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Warehouse Pickup', style: TextStyle(fontWeight: FontWeight.w700)),
        Card(
          child: ListTile(
            title: Text(order.warehouse.name),
            subtitle: Text('${order.warehouse.address}\n${order.warehouse.phone}\n${order.warehouse.distanceKm} km away'),
          ),
        ),
        const SizedBox(height: 12),
        const Text('Delivery Details', style: TextStyle(fontWeight: FontWeight.w700)),
        Card(
          child: ListTile(
            title: Text(order.mosque.name),
            subtitle: Text('Packages: ${order.packages}\nContact: Mosque coordinator'),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: () => context.push('/supplier/upload/${order.id}'), child: const Text('Upload Proof')),
      ]),
    );
  }
}

class UploadProofScreen extends StatefulWidget {
  const UploadProofScreen({super.key, required this.id});
  final String id;
  @override
  State<UploadProofScreen> createState() => _UploadProofScreenState();
}

class _UploadProofScreenState extends State<UploadProofScreen> {
  final picker = ImagePicker();
  final notes = TextEditingController();
  final List<String> photos = [];
  String? video;

  @override
  void dispose() {
    notes.dispose();
    super.dispose();
  }

  Future<void> pickPhoto() async {
    if (photos.length >= 4) return;
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => photos.add(x.path));
  }

  Future<void> pickVideo() async {
    final x = await picker.pickVideo(source: ImageSource.gallery);
    if (x != null) setState(() => video = x.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Proof')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Wrap(spacing: 8, children: photos.map((p) => Chip(label: Text(p.split('\\').last))).toList()),
        TextButton.icon(onPressed: pickPhoto, icon: const Icon(Icons.photo), label: const Text('Add photo (max 4)')),
        TextButton.icon(onPressed: pickVideo, icon: const Icon(Icons.videocam), label: const Text('Add optional video')),
        if (video != null) Text('Video selected: ${video!.split('\\').last}'),
        TextField(controller: notes, maxLines: 4, decoration: const InputDecoration(labelText: 'Notes')),
        const SizedBox(height: 8),
        const Text('📸 Photos sent to donor & admin', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            context.read<SaqiaState>().updateProof(widget.id, photos, notes.text);
            context.go('/supplier/complete/${widget.id}');
          },
          child: const Text('Submit Proof'),
        ),
      ]),
    );
  }
}

class SupplierCompletionScreen extends StatelessWidget {
  const SupplierCompletionScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.check_circle, color: Colors.teal, size: 44),
              Text('Delivery Complete', style: Theme.of(context).textTheme.titleLarge),
              Text('Order $id confirmed.'),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () => context.go('/supplier/home'), child: const Text('Back to Tasks')),
            ]),
          ),
        ),
      ),
    );
  }
}

class SupplierProfileScreen extends StatelessWidget {
  const SupplierProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = context.watch<SaqiaState>().supplierOrders();
    final deliveries = orders.where((e) => e.status == OrderStatus.completed).length;
    final packages = orders.fold<int>(0, (sum, o) => sum + o.packages);
    final inProgress = orders.where((e) => e.status == OrderStatus.inProgress).length;
    return SupplierScaffold(
      index: 1,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
        children: [
          const ProfileTopCard(
            name: 'Mohammed Ali',
            roleLabel: 'Supplier',
            leadingIcon: Icons.person_outline_rounded,
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Row(
              children: const [
                StatBadge(label: 'Deliveries', value: '42', valueColor: AppTheme.teal),
                SizedBox(width: 10),
                StatBadge(label: 'Rating', value: '4.8', valueColor: Color(0xFFE38B2C)),
                SizedBox(width: 10),
                StatBadge(label: 'On-Time', value: '96%', valueColor: Color(0xFF12A979)),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Information', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  const _InfoRow(icon: Icons.email_outlined, label: 'Email', value: 'mohammed.ali@email.com'),
                  const SizedBox(height: 8),
                  const _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: '+1 (555) 987-6543'),
                  const SizedBox(height: 8),
                  const _InfoRow(icon: Icons.location_on_outlined, label: 'Service Area', value: 'Downtown & West Side'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Column(
                children: [
                  MenuActionTile(
                    icon: Icons.local_shipping_outlined,
                    title: 'Current Tasks',
                    subtitle: '$inProgress deliveries in progress',
                    onTap: () => context.go('/supplier/home'),
                  ),
                  MenuActionTile(
                    icon: Icons.verified_user_outlined,
                    title: 'Performance Insights',
                    subtitle: '$deliveries completed • $packages packages',
                    onTap: () {},
                  ),
                  MenuActionTile(
                    icon: Icons.shield_outlined,
                    title: 'Support & Policies',
                    subtitle: 'Review delivery and proof guidelines',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: MenuActionTile(
                icon: Icons.logout_rounded,
                title: 'Log out',
                subtitle: 'Sign out of your supplier account',
                titleColor: AppTheme.terracotta,
                onTap: () {
                  context.read<SaqiaState>().logout();
                  context.go('/role');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
