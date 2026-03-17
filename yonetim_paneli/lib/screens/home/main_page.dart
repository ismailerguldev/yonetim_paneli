import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:yonetim_paneli/core/models/project.model.dart';
import 'package:yonetim_paneli/core/models/user.model.dart';
import 'package:yonetim_paneli/core/notifiers.dart';
import 'package:yonetim_paneli/core/services/project_service.dart';
import 'package:yonetim_paneli/core/widgets/project_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Header()),
          SliverToBoxAdapter(child: Infos()),
          SliverToBoxAdapter(child: Projects()),
          SliverToBoxAdapter(child: Menu()),
        ],
      ),
    );
  }
}

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hızlı Menü",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(72, 0, 72, 0),
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: [
              AddNewProject(),
              GestureDetector(
                onTap: () => context.push("/profile"),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x13000000),
                        blurRadius: 15,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 48,
                        color: Color(0xFF0F6DF0),
                      ),
                      Text(
                        "Profil",
                        style: TextStyle(
                          color: Color(0xFF0F6DF0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

class AddNewProject extends StatelessWidget {
  const AddNewProject({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // DateTime now = DateTime.now();
        // DateTime otuzGunSonra = now.add(Duration(days: 4,hours: 22,minutes: 20,seconds: 30));
        // String endDateIso = otuzGunSonra.toIso8601String();
        // ProjectService.createProject(name: "Bu ilk proje", description: "Bu bayağı ilk proje", priority: "Halledilir", endDate: endDateIso);
        showModalBottomSheet(
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          context: context,
          builder: (context) => NewProjectModal(),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0F6DF0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x13000000),
              blurRadius: 15,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, size: 48, color: Colors.white),
            Text(
              "Yeni Proje",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewProjectModal extends ConsumerStatefulWidget {
  const NewProjectModal({super.key});

  @override
  ConsumerState<NewProjectModal> createState() => _NewProjectModalState();
}

class _NewProjectModalState extends ConsumerState<NewProjectModal> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priorityController = TextEditingController();
  DateTime? _endDate;
  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 50,
              height: 5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Yeni Proje Oluştur", style: TextStyle(fontSize: 22)),
                IconButton(
                  onPressed: () {
                    _endDate = null;
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Proje Adı",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Örn: Frontend Login Form",
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Bitim tarihi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      DateTime? secilen = await showOmniDateTimePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        is24HourMode: true,
                      );
                      if (secilen != null) {
                        setState(() {
                          _endDate = secilen;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.grey.shade500,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            _endDate == null
                                ? "Tarih ve Saat Seçiniz"
                                : "${_endDate!.day}/${_endDate!.month}/${_endDate!.year} - ${_endDate!.hour}:${_endDate!.minute}",
                            style: TextStyle(
                              color: _endDate == null
                                  ? Colors.grey.shade600
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Açıklama",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Proje detaylarını yazın...",
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Öncelik",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _priorityController,
                    decoration: InputDecoration(
                      hintText: "Örn: Acil",
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0F6DF0),
                        ),
                        onPressed: () async {
                          String endDateIso = _endDate!.toIso8601String();
                          await ref.read(projectProvider.notifier).addProject({
                            "name": _nameController.text,
                            "description": _descController.text,
                            "priority": _priorityController.text,
                            "end_date": endDateIso,
                          });
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Projeyi Oluştur",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Projects extends ConsumerWidget {
  const Projects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Aktif Projeler",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 230,
          child: projectState.when(
            data: (projects) {
              if (projects == null || projects.isEmpty) {
                return Center(child: Text("Henü bir projeniz yok"));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: projects.length,
                itemBuilder: (context, index) => ProjectCard(
                  endDate: projects[index].endDate,
                  name: projects[index].name,
                  priority: projects[index].priority,
                  progress: projects[index].progress,
                  id: projects[index].id,
                ),
              );
            },
            error: (error, stack) => Center(
              child: Text("Projeler yüklenirken bir hata oluştu. $error"),
            ),
            loading: () =>
                Center(child: CircularProgressIndicator(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}

class Infos extends ConsumerWidget {
  const Infos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectProvider);
    int countOfDone = 0;
    int countOfOther = 0;
    projects.whenData((value) {
      if (value == null || value.isEmpty) {
        countOfOther = 0;
        countOfDone = 0;
      } else {
        countOfDone = value.where((e) => e.progress == 100).toList().length;
        countOfOther = value.length - countOfDone;
      }
    });
    return Column(
      children: [
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xAAE07116), Color(0xFFEBA66E)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Icon(Icons.pending_actions_rounded, color: Colors.white),
                    Text(
                      "Bitirilmemiş\nProjeler $countOfOther",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0F6DF0),
                      Color.fromARGB(255, 7, 69, 156),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Icon(Icons.task_outlined, color: Colors.white),
                    Text(
                      "Tamamlanmış\nProjeler $countOfDone",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(32),
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.person, color: Colors.blue.shade600),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hoş geldiniz",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  "${user?.firstName} ${user?.lastName}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(32),
              ),
              alignment: Alignment.centerRight,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: BoxBorder.all(color: Colors.white, width: 2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
