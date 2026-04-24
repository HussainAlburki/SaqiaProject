import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saqia/core/models/saqia_models.dart';
import 'package:saqia/core/state/saqia_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2500), () => context.go('/role'));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.water_drop, size: 78, color: Color(0xFF0D9488)),
            Text('Saqia', style: Theme.of(context).textTheme.headlineMedium),
          ]),
        ),
      ),
    );
  }
}

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Choose your role', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          _RoleCard(
            icon: Icons.favorite_rounded,
            title: "I'm a Donor",
            onTap: () => context.push('/auth/donor'),
          ),
          const SizedBox(height: 14),
          _RoleCard(
            icon: Icons.local_shipping_rounded,
            title: "I'm a Supplier",
            onTap: () => context.push('/auth/supplier'),
          ),
          const SizedBox(height: 14),
          TextButton(onPressed: () => context.push('/auth/admin'), child: const Text('Continue as Admin')),
        ]),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.role});
  final UserRole role;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUp = true;
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roleName = widget.role.name[0].toUpperCase() + widget.role.name.substring(1);
    return Scaffold(
      appBar: AppBar(title: Text('$roleName Authentication')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(isSignUp ? 'Create account' : 'Welcome back', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        if (isSignUp) ...[
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 10),
          TextField(controller: phone, decoration: const InputDecoration(labelText: 'Phone')),
          const SizedBox(height: 10),
        ],
        TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
        const SizedBox(height: 10),
        TextField(controller: pass, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.read<SaqiaState>().login(userRole: widget.role, name: name.text.isEmpty ? 'Amina Khan' : name.text);
            context.go(widget.role == UserRole.donor ? '/donor/home' : widget.role == UserRole.supplier ? '/supplier/home' : '/admin');
          },
          child: Text(isSignUp ? 'Sign Up' : 'Sign In'),
        ),
        TextButton(onPressed: () => setState(() => isSignUp = !isSignUp), child: Text(isSignUp ? 'Already have an account? Sign In' : 'No account? Sign Up')),
      ]),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 32),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: onTap,
      ),
    );
  }
}
