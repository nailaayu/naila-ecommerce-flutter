import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/shop_controller.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopController>();
    final primary = Theme.of(context).colorScheme.primary;
    final isEnglish = shop.language == 'English';

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: primary.withOpacity(0.16)),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              _ProfileAvatar(
                imageBytes: shop.profileImageBytes,
                radius: 55,
              ),
              const SizedBox(height: 16),
              Text(
                shop.userName.isEmpty ? 'Naila Student' : shop.userName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 5),
              Text(
                shop.userEmail.isEmpty ? 'naila@gmail.com' : shop.userEmail,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(isEnglish ? 'Edit Profile' : 'Edit Profil'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          isEnglish ? 'Account Features' : 'Fitur Akun',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ProfileShortcut(
                icon: Icons.settings_outlined,
                title: isEnglish ? 'Settings' : 'Pengaturan',
                subtitle: isEnglish ? 'Language & theme' : 'Bahasa & tema',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ProfileShortcut(
                icon: Icons.support_agent_outlined,
                title: isEnglish ? 'Help' : 'Bantuan',
                subtitle: isEnglish ? 'Customer service' : 'Pusat bantuan',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen(openHelp: true))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Center(
          child: SizedBox(
            width: 210,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.red),
              label: const Text(
                'Logout',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileShortcut extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileShortcut({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: primary.withOpacity(0.16)),
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primary),
              ),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _ProfileAvatar extends StatelessWidget {
  final Uint8List? imageBytes;
  final double radius;

  const _ProfileAvatar({required this.imageBytes, required this.radius});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.18), primary.withOpacity(0.06)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        backgroundImage: imageBytes == null ? null : MemoryImage(imageBytes!),
        child: imageBytes == null
            ? ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: radius * 1.65,
                  height: radius * 1.65,
                  fit: BoxFit.cover,
                ),
              )
            : null,
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    final shop = context.read<ShopController>();
    _nameController.text = shop.userName;
    _emailController.text = shop.userEmail;
    _phoneController.text = shop.userPhone;
    _addressController.text = shop.userAddress;
    _loaded = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }


  Future<void> _pickProfilePhoto() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image == null || !mounted) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      context.read<ShopController>().setProfilePhoto(bytes);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil ditambahkan.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto belum bisa dipilih di perangkat ini.')),
      );
    }
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan email wajib diisi.')),
      );
      return;
    }

    context.read<ShopController>().setUserProfile(
          name: name,
          email: email,
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(title: const Text('EDIT PROFIL')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: primary.withOpacity(0.16)),
              ),
              child: Column(
                children: [
                  Consumer<ShopController>(
                    builder: (context, shop, _) => Column(
                      children: [
                        _ProfileAvatar(imageBytes: shop.profileImageBytes, radius: 48),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _pickProfilePhoto,
                          icon: const Icon(Icons.add_a_photo_outlined),
                          label: const Text('Tambah Foto'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _ProfileField(
                    controller: _nameController,
                    label: 'Nama Lengkap',
                    icon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  _ProfileField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  _ProfileField(
                    controller: _phoneController,
                    label: 'Nomor Telepon',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  _ProfileField(
                    controller: _addressController,
                    label: 'Alamat',
                    icon: Icons.location_on_outlined,
                    minLines: 2,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveProfile,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Simpan Profil'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int minLines;
  final int maxLines;

  const _ProfileField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final bool openHelp;
  const SettingsScreen({super.key, this.openHelp = false});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _helpShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.openHelp && !_helpShown) {
      _helpShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showHelp();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopController>();
    final primary = Theme.of(context).colorScheme.primary;
    final isEnglish = shop.language == 'English';

    return Scaffold(
      appBar: AppBar(title: Text(isEnglish ? 'SETTINGS' : 'PENGATURAN')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: primary.withOpacity(0.16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEnglish ? 'Application Settings' : 'Pengaturan Aplikasi',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  isEnglish ? 'Adjust app language, theme color, and display mode.' : 'Atur bahasa, warna tema, dan mode tampilan aplikasi.',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 18),
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: isEnglish ? 'Language' : 'Bahasa',
                  onTap: _chooseLanguage,
                ),
                _SettingsTile(
                  icon: Icons.palette_outlined,
                  title: isEnglish ? 'Theme' : 'Tema',
                  onTap: _chooseTheme,
                ),
                _SettingsSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: isEnglish ? 'Display Mode' : 'Mode Tampilan',
                  value: shop.darkMode,
                  onChanged: (value) => context.read<ShopController>().setDarkMode(value),
                ),
                _SettingsTile(
                  icon: Icons.support_agent_outlined,
                  title: isEnglish ? 'Help Center' : 'Pusat Bantuan',
                  onTap: _showHelp,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              'NAILA E-COMMERCE',
              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    final shop = context.read<ShopController>();
    final isEnglish = shop.language == 'English';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text(isEnglish ? 'Help Center' : 'Pusat Bantuan'),
        content: Text(
          isEnglish
              ? 'Customer service is ready to help with account, payment, and order questions.'
              : 'Customer service NAILA E-COMMERCE siap membantu akun, pembayaran, dan pesanan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Oke'),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseLanguage() async {
    final shop = context.read<ShopController>();
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(shop.language == 'English' ? 'Choose Language' : 'Pilih Bahasa', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              _OptionTile(
                title: 'Indonesia',
                selected: shop.language == 'Indonesia',
                onTap: () => Navigator.pop(sheetContext, 'Indonesia'),
              ),
              _OptionTile(
                title: 'English',
                selected: shop.language == 'English',
                onTap: () => Navigator.pop(sheetContext, 'English'),
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted || result == null) return;
    context.read<ShopController>().setLanguage(result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result == 'English' ? 'Language changed.' : 'Bahasa berhasil diubah.')),
    );
  }

  Future<void> _chooseTheme() async {
    final shop = context.read<ShopController>();
    final options = <String, Color>{
      'Biru': const Color(0xFF1565C0),
      'Kuning': const Color(0xFFF9A825),
      'Hijau': const Color(0xFF2E7D32),
      'Merah': const Color(0xFFC62828),
    };
    final result = await showModalBottomSheet<Color>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (sheetContext) => SafeArea(
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shop.language == 'English' ? 'Choose Theme' : 'Pilih Tema',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          ...options.entries.map(
            (entry) => _OptionTile(
              title: entry.key,
              selected: shop.themeColor.value == entry.value.value,
              leading: CircleAvatar(
                backgroundColor: entry.value,
                radius: 13,
              ),
              onTap: () => Navigator.pop(sheetContext, entry.value),
            ),
          ),
        ],
      ),
    ),
  ),
),
    );

    if (!mounted || result == null) return;
    context.read<ShopController>().setThemeColor(result);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tema berhasil diubah.')));
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Icon(icon, color: primary),
                const SizedBox(width: 12),
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800))),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({required this.icon, required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, color: primary),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800))),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final bool selected;
  final Widget? leading;
  final VoidCallback onTap;

  const _OptionTile({required this.title, required this.selected, required this.onTap, this.leading});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        tileColor: selected ? primary.withOpacity(0.12) : primary.withOpacity(0.04),
        leading: leading,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        trailing: selected ? Icon(Icons.check_circle, color: primary) : const Icon(Icons.circle_outlined, size: 20),
      ),
    );
  }
}
