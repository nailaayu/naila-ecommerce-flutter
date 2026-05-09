import 'package:flutter/material.dart';

class RegisterResult {
  final String name;
  final String email;
  final String password;

  const RegisterResult({required this.name, required this.email, required this.password});
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _created() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showMessage('Lengkapi semua data akun terlebih dahulu.');
      return;
    }
    if (password != confirm) {
      _showMessage('Konfirmasi password belum sama.');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Akun Berhasil Dibuat'),
        content: const Text('Silakan masuk menggunakan akun yang baru dibuat.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, RegisterResult(name: name, email: email, password: password));
            },
            child: const Text('Oke'),
          ),
        ],
      ),
    );
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
              padding: const EdgeInsets.all(22),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.96), borderRadius: BorderRadius.circular(28)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset('assets/images/logo.png', width: 95, height: 95, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text('Daftar Akun', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 18),
                    TextField(controller: _nameController, decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline), labelText: 'Nama Lengkap')),
                    const SizedBox(height: 14),
                    TextField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(prefixIcon: Icon(Icons.email_outlined), labelText: 'Email')),
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
                    const SizedBox(height: 14),
                    TextField(
                      controller: _confirmController,
                      obscureText: _hideConfirm,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_reset),
                        labelText: 'Konfirmasi Password',
                        suffixIcon: IconButton(onPressed: () => setState(() => _hideConfirm = !_hideConfirm), icon: Icon(_hideConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: _created, child: const Text('Buat Akun')),
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
