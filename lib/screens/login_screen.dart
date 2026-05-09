import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/shop_controller.dart';
import 'app_shell.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _hasAccount = false;
  String _registeredName = '';
  String _registeredEmail = '';
  String _registeredPassword = '';

  @override
  void dispose() {
    _nameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final nameOrEmail = _nameOrEmailController.text.trim();
    final password = _passwordController.text.trim();
    if (nameOrEmail.isEmpty || password.isEmpty) {
      _showPopup('Nama atau email dan password wajib diisi.');
      return;
    }

    if (_hasAccount && password != _registeredPassword) {
      _showPopup('Password belum sesuai dengan akun yang sudah dibuat.');
      return;
    }

    final displayName = nameOrEmail.contains('@')
        ? (_registeredName.isNotEmpty ? _registeredName : nameOrEmail.split('@').first)
        : nameOrEmail;
    final email = nameOrEmail.contains('@')
        ? nameOrEmail
        : (_registeredEmail.isNotEmpty ? _registeredEmail : '${nameOrEmail.toLowerCase().replaceAll(' ', '')}@gmail.com');

    context.read<ShopController>().setUserProfile(name: displayName, email: email);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell()));
  }

  void _showPopup(String message) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Informasi Akun'),
        content: Text(message, style: const TextStyle(height: 1.4)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
          ElevatedButton(onPressed: () { Navigator.pop(context); _openRegister(); }, child: const Text('Daftar Akun')),
        ],
      ),
    );
  }

  Future<void> _openRegister() async {
    final result = await Navigator.push<RegisterResult>(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
    if (result != null) {
      setState(() {
        _hasAccount = true;
        _registeredName = result.name;
        _registeredEmail = result.email;
        _registeredPassword = result.password;
        _nameOrEmailController.text = result.name;
        _passwordController.text = result.password;
      });
      context.read<ShopController>().setUserProfile(name: result.name, email: result.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF4FF), Color(0xFFB8D9FF), Color(0xFF1565C0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.96), borderRadius: BorderRadius.circular(28)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: ClipRRect(borderRadius: BorderRadius.circular(26), child: Image.asset('assets/images/logo.png', width: 110, height: 110, fit: BoxFit.cover))),
                    const SizedBox(height: 18),
                    const Text('Masuk Akun', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 22),
                    TextField(controller: _nameOrEmailController, decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline), labelText: 'Nama atau Email')),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        labelText: 'Password',
                        suffixIcon: IconButton(onPressed: () => setState(() => _hidePassword = !_hidePassword), icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(onPressed: _login, child: const Text('Masuk')),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: OutlinedButton(onPressed: _openRegister, child: const Text('Daftar Akun'))),
                        const SizedBox(width: 10),
                        Expanded(child: OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())), child: const Text('Lupa Password'))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
