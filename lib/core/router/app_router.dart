import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saqia/core/models/saqia_models.dart';
import 'package:saqia/core/state/saqia_state.dart';
import 'package:saqia/features/admin/admin_dashboard_screen.dart';
import 'package:saqia/features/auth/auth_screens.dart';
import 'package:saqia/features/donor/donor_screens.dart';
import 'package:saqia/features/supplier/supplier_screens.dart';

class AppRouter {
  static GoRouter create(SaqiaState state) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/role', builder: (_, __) => const RoleSelectionScreen()),
        GoRoute(path: '/auth/donor', builder: (_, __) => const AuthScreen(role: UserRole.donor)),
        GoRoute(path: '/auth/supplier', builder: (_, __) => const AuthScreen(role: UserRole.supplier)),
        GoRoute(path: '/auth/admin', builder: (_, __) => const AuthScreen(role: UserRole.admin)),
        GoRoute(path: '/donor/home', builder: (_, __) => const DonorHomeScreen()),
        GoRoute(path: '/donor/history', builder: (_, __) => const DonorHistoryScreen()),
        GoRoute(path: '/donor/profile', builder: (_, __) => const DonorProfileScreen()),
        GoRoute(path: '/donor/mosque/:id', builder: (_, s) => MosqueDetailsScreen(id: s.pathParameters['id']!)),
        GoRoute(path: '/donor/donation/:id', builder: (_, s) => DonationScreen(mosqueId: s.pathParameters['id']!)),
        GoRoute(path: '/donor/payment/:id', builder: (_, s) => PaymentScreen(mosqueId: s.pathParameters['id']!)),
        GoRoute(path: '/donor/success/:id', builder: (_, s) => DonationSuccessScreen(orderId: s.pathParameters['id']!)),
        GoRoute(path: '/donor/order/:id', builder: (_, s) => DonorOrderDetailsScreen(id: s.pathParameters['id']!)),
        GoRoute(path: '/supplier/home', builder: (_, __) => const SupplierHomeScreen()),
        GoRoute(path: '/supplier/profile', builder: (_, __) => const SupplierProfileScreen()),
        GoRoute(path: '/supplier/order/:id', builder: (_, s) => SupplierOrderDetailsScreen(id: s.pathParameters['id']!)),
        GoRoute(path: '/supplier/upload/:id', builder: (_, s) => UploadProofScreen(id: s.pathParameters['id']!)),
        GoRoute(path: '/supplier/complete/:id', builder: (_, s) => SupplierCompletionScreen(id: s.pathParameters['id']!)),
        GoRoute(path: '/admin', builder: (_, __) => const AdminDashboardScreen()),
      ],
      errorBuilder: (_, __) => const Scaffold(body: Center(child: Text('Route not found'))),
    );
  }
}
