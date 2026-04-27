import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saqia/core/models/saqia_models.dart';
import 'package:saqia/core/state/saqia_state.dart';
import 'package:saqia/core/theme/app_theme.dart';
import 'package:saqia/core/widgets/ui.dart';

class DonorScaffold extends StatelessWidget {
  const DonorScaffold({super.key, required this.child, required this.index});
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(
          i == 0
              ? '/donor/home'
              : i == 1
              ? '/donor/history'
              : '/donor/profile',
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DonorHomeScreen extends StatelessWidget {
  const DonorHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final mosques = context.watch<SaqiaState>().mosques;
    return DonorScaffold(
      index: 0,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const GradientHeader(
            title: 'Saqia Donor',
            subtitle: 'Support mosques with clean water',
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search mosques',
            ),
          ),
          const SizedBox(height: 12),
          if (mosques.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('No mosques available yet.'),
              ),
            ),
          ...List.generate(
            mosques.length,
            (i) => AnimatedContainer(
              duration: Duration(milliseconds: 350 + (i * 100)),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: ListTile(
                  onTap: () => context.push('/donor/mosque/${mosques[i].id}'),
                  title: Text(mosques[i].name),
                  subtitle: Text(
                    '${mosques[i].distanceKm} km • ${mosques[i].stockLevel} packs in stock',
                  ),
                  trailing: mosques[i].stockLevel < 15
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE07A5F),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'LOW STOCK',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MosqueDetailsScreen extends StatelessWidget {
  const MosqueDetailsScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final mosque = context.watch<SaqiaState>().mosqueById(id);
    if (mosque == null) {
      return const Scaffold(body: Center(child: Text('Mosque not found')));
    }
    return Scaffold(
      appBar: AppBar(title: Text(mosque.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mosque.address),
                  const SizedBox(height: 12),
                  const Text('Prayer Times'),
                  ...mosque.prayerTimes.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('${e.key}: ${e.value}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.report_problem_rounded),
            label: const Text('Report Water Shortage'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.push('/donor/donation/$id'),
            child: const Text('Donate Now'),
          ),
        ],
      ),
    );
  }
}

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key, required this.mosqueId});
  final String mosqueId;
  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  double qty = 10;
  @override
  Widget build(BuildContext context) {
    final total = qty * 5;
    return Scaffold(
      appBar: AppBar(title: const Text('Donation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Packages: ${qty.toInt()}'),
            Slider(
              min: 5,
              max: 50,
              divisions: 45,
              value: qty,
              onChanged: (v) => setState(() => qty = v),
            ),
            Text('Total: \$${total.toStringAsFixed(0)}'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                context.read<SaqiaState>().selectedPackages = qty.toInt();
                context.push('/donor/payment/${widget.mosqueId}');
              },
              child: const Text('Continue to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.mosqueId});
  final String mosqueId;
  @override
  Widget build(BuildContext context) {
    final mosque = context.watch<SaqiaState>().mosqueById(mosqueId);
    if (mosque == null) {
      return const Scaffold(body: Center(child: Text('Mosque not found')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...['Credit Card', 'Apple Pay', 'Google Pay'].map(
            (e) => Card(
              child: ListTile(
                title: Text(e),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final order = context.read<SaqiaState>().createDonation(mosque);
              context.go('/donor/success/${order.id}');
            },
            child: const Text('Pay and Confirm'),
          ),
        ],
      ),
    );
  }
}

class DonationSuccessScreen extends StatefulWidget {
  const DonationSuccessScreen({super.key, required this.orderId});
  final String orderId;
  @override
  State<DonationSuccessScreen> createState() => _DonationSuccessScreenState();
}

class _DonationSuccessScreenState extends State<DonationSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(parent: controller, curve: Curves.elasticOut),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.celebration_rounded,
                    color: Colors.teal,
                    size: 48,
                  ),
                  Text(
                    'Donation Successful',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('Order #${widget.orderId}'),
                  const Text('Delivery proof will be uploaded by supplier.'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.go('/donor/history'),
                    child: const Text('View History'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DonorHistoryScreen extends StatelessWidget {
  const DonorHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = context.watch<SaqiaState>().donorOrders();
    return DonorScaffold(
      index: 1,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: orders
            .map(
              (o) => Card(
                child: ListTile(
                  onTap: () => context.push('/donor/order/${o.id}'),
                  title: Text('${o.mosque.name} • ${o.packages} packs'),
                  subtitle: Text(o.id),
                  trailing: StatusChip(status: o.status),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class DonorOrderDetailsScreen extends StatelessWidget {
  const DonorOrderDetailsScreen({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final order = context.watch<SaqiaState>().byId(id)!;
    return Scaffold(
      appBar: AppBar(title: Text('Order ${order.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          StatusChip(status: order.status),
          const SizedBox(height: 12),
          Text('Mosque: ${order.mosque.name}'),
          Text('Packages: ${order.packages}'),
          Text('Total: \$${order.totalAmount.toStringAsFixed(0)}'),
          const SizedBox(height: 12),
          const Text('Delivery Proof'),
          if (order.proof == null) const Text('No proof yet'),
          if (order.proof != null) ProofGallery(photos: order.proof!.photos),
        ],
      ),
    );
  }
}

class DonorProfileScreen extends StatelessWidget {
  const DonorProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = context.watch<SaqiaState>().donorOrders();
    final totalPackages = orders.fold<int>(0, (sum, o) => sum + o.packages);
    final total = orders.fold<double>(0, (sum, o) => sum + o.totalAmount);
    final completed = orders
        .where((o) => o.status == OrderStatus.completed)
        .length;
    return DonorScaffold(
      index: 2,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
        children: [
          ProfileTopCard(
            name: context.watch<SaqiaState>().currentUserName ?? 'Amina Khan',
            roleLabel: 'Donor',
            leadingIcon: Icons.favorite_border_rounded,
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Row(
              children: [
                StatBadge(
                  label: 'Packages',
                  value: '$totalPackages',
                  valueColor: AppTheme.teal,
                ),
                const SizedBox(width: 10),
                StatBadge(
                  label: 'Donated',
                  value: '\$${total.toStringAsFixed(0)}',
                  valueColor: const Color(0xFF0A9E8C),
                ),
                const SizedBox(width: 10),
                StatBadge(
                  label: 'Completed',
                  value: '$completed',
                  valueColor: const Color(0xFF12A979),
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Information',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Name: ${context.watch<SaqiaState>().currentUserName ?? 'Amina Khan'}',
                  ),
                  const SizedBox(height: 6),
                  const Text('Email: donor@saqia.app'),
                  const SizedBox(height: 6),
                  Text('Mosques Helped: ${orders.length}'),
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
                    icon: Icons.history_rounded,
                    title: 'Donation History',
                    subtitle: 'Track order progress and delivery proofs',
                    onTap: () => context.go('/donor/history'),
                  ),
                  MenuActionTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Alerts & Reminders',
                    subtitle: 'Get low-stock updates from mosques',
                    onTap: () {},
                  ),
                  MenuActionTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    subtitle: 'Support, FAQs and contact options',
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
                subtitle: 'Sign out of your donor account',
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
