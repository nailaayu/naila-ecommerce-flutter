import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  void _saved(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Password Disimpan'),
        content: const Text('Password baru berhasil disimpan untuk tampilan tugas aplikasi.'),
        actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('Oke'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFEAF4FF), Color(0xFFB8D9FF), Color(0xFF1565C0)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
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
                    Center(child: ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset('assets/images/logo.png', width: 95, height: 95, fit: BoxFit.cover))),
                    const SizedBox(height: 18),
                    const Text('Lupa Password', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 18),
                    const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.email_outlined), labelText: 'Email')),
                    const SizedBox(height: 14),
                    const TextField(obscureText: true, decoration: InputDecoration(prefixIcon: Icon(Icons.lock_clock_outlined), labelText: 'Password Lama')),
                    const SizedBox(height: 14),
                    const TextField(obscureText: true, decoration: InputDecoration(prefixIcon: Icon(Icons.lock_reset), labelText: 'Password Baru')),
                    const SizedBox(height: 12),
                    const Text('Jika lupa password lama, gunakan email untuk membuat password baru.', style: TextStyle(height: 1.4, fontSize: 13)),
                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: () => _saved(context), child: const Text('Simpan Password')),
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
