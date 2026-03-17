import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yonetim_paneli/core/models/user.model.dart';
import 'package:yonetim_paneli/core/notifiers.dart';
import 'package:yonetim_paneli/core/services/profile_service.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        ProfileSection(user: user),
        SettingsSection(),
      ],
    );
  }
}

class SettingsSection extends ConsumerWidget {
  const SettingsSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 8,
        children: [
          SizedBox(height: 16),
          SettingsItem(
            icon: Icon(Icons.lock_rounded),
            title: "Parola",
            subTitle: "Parolanızı değiştirin",
            id: "password",
          ),
          SizedBox(height: 12),
          Card(
            elevation: 0.5,
            child: ListTile(
              onTap: () => ref.read(authProvider.notifier).logout(),
              leading: CircleAvatar(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade700,
                child: Icon(Icons.logout),
              ),
              title: Text(
                "Hesaptan çıkış yap",
                style: TextStyle(color: Colors.red.shade700),
              ),
              subtitle: Text(
                "Daha sonra tekrar girebilirsiniz.",
                style: TextStyle(color: Colors.red.shade400),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.red.shade700),
              tileColor: Colors.red.shade50,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.icon,
    required this.subTitle,
    required this.title,
    required this.id,
  });
  final String title;
  final String subTitle;
  final Icon icon;
  final String id;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => FormModal(title: title, id: id),
          );
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade200,
          child: icon,
        ),
        title: Text(title),
        subtitle: Text(subTitle),
        trailing: Icon(Icons.chevron_right),
        tileColor: Colors.grey.shade200,
      ),
    );
  }
}

class FormModal extends ConsumerStatefulWidget {
  const FormModal({super.key, required this.title, required this.id});

  final String title;
  final String id;

  @override
  ConsumerState<FormModal> createState() => _FormModalState();
}

class _FormModalState extends ConsumerState<FormModal> {
  late final TextEditingController firstValue;
  late final TextEditingController lastValue;
  @override
  void initState() {
    super.initState();
    firstValue = TextEditingController();
    lastValue = TextEditingController();
  }

  @override
  void dispose() {
    firstValue.dispose();
    lastValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        "${widget.title} Değiştir",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lütfen yeni ${widget.title} bilginizi aşağıya girin.",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: firstValue,
            decoration: InputDecoration(
              hintText: "Mevcut ${widget.title}",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: lastValue,
            decoration: InputDecoration(
              hintText: "Yeni ${widget.title}",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "İptal",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0f6DF0),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () async {
            final oldValue = firstValue.text.trim();
            final newValue = lastValue.text.trim();
            if (oldValue.isEmpty || newValue.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Lütfen tüm alanları doldurun.")),
              );
              return;
            }
            final user = ref.read(authProvider).value;
            if (user == null) return;
            if ((widget.id == "email" && user.email != oldValue) ||
                (widget.id == "phone" && user.phone != oldValue)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Mevcut bilgilerinizi hatalı girdiniz."),
                ),
              );
              return;
            }
            if (widget.id == "password") {
              await ProfileService.changePassword(oldValue, newValue);
            }
            if (!context.mounted) return;
            Navigator.pop(context);
          },
          child: const Text(
            "Kaydet", 
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF0F6DF0),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.person, color: Colors.blue.shade600, size: 36),
          ),
          SizedBox(height: 16),
          Text(
            "${user?.firstName} ${user?.lastName}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text("${user?.email}", style: TextStyle(color: Colors.white)),
          SizedBox(height: 2),
          Text("+90 ${user?.phone}", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
