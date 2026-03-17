import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yonetim_paneli/core/models/project.model.dart';
import 'package:yonetim_paneli/core/notifiers.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final Project projectData;
  const ProjectDetailScreen({super.key, required this.projectData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectDetail = ref.watch(projectDetailProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red.shade100),
                  ),
                  child: Text(
                    projectData.priority,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await ref.read(projectProvider.notifier).removeProject(projectData.id);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  }, 
                  icon: Icon(Icons.delete, color: Colors.red.shade300),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              projectData.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  "${projectData.endDate.day}.${projectData.endDate.month}.${projectData.endDate.year} / ${projectData.endDate.hour}:${projectData.endDate.minute} tarihine kadar",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            projectDetail.when(
              data: (detail) {
                if (detail == null) {
                  return Text("Proje çekilirken bir hata oluştu");
                }
                return Text(
                  detail.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                );
              },
              error: (error, stack) => Text("Bir hata meydana geldi"),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(color: Color(0xFF0F6DF0)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "İlerleme",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "%${projectDetail.value?.progress}",
                        style: TextStyle(
                          color: const Color(0xFF0f6DF0),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: projectDetail.value != null
                          ? projectDetail.value!.progress / 100
                          : 0,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF0f6DF0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Görevler",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return AddNewTask(projectId: projectData.id);
                      },
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Yeni Ekle"),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0f6DF0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            projectDetail.when(
              data: (data) {
                if (data == null) {
                  return Text("");
                }
                if (data.tasks.isEmpty) {
                  return Center(
                    child: Text("Bu projeye henüz task eklenmemiş."),
                  );
                }
                return Column(
                  children: data.tasks
                      .map(
                        (e) => TaskItem(
                          taskName: e.taskDescription,
                          isCompleted: e.isDone,
                          projectId: projectData.id,
                          taskId: e.id,
                          progress: projectDetail.value!.progress,
                        ),
                      )
                      .toList(),
                );
              },
              error: (error, stackTrace) =>
                  Text("Tasklar çekilirken bir hata oluştu"),
              loading: () => Text("Yükleniyor"),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends ConsumerWidget {
  const TaskItem({
    super.key,
    required this.taskName,
    required this.isCompleted,
    required this.taskId,
    required this.projectId,
    required this.progress,
  });

  final String taskName;
  final bool isCompleted;
  final String taskId;
  final String projectId;
  final int progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted ? Colors.grey.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted ? Colors.grey.shade200 : Colors.grey.shade300,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          leading: Checkbox(
            value: isCompleted,
            activeColor: const Color(0xFF0f6DF0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (value) {
              int val = value == true ? 1 : 0;
              print(isCompleted);
              ref
                  .read(projectDetailProvider.notifier)
                  .updateProjectTask(taskId, val, projectId);
            },
          ),
          title: Text(
            taskName,
            style: TextStyle(
              fontSize: 15,
              color: isCompleted ? Colors.grey.shade500 : Colors.black87,
              decoration: isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          trailing: InkWell(
            onTap: () {
              ref
                  .read(projectDetailProvider.notifier)
                  .deleteProjectTask(taskId, projectId);
            },
            child: Icon(Icons.delete, color: Colors.red.shade300),
          ),
        ),
      ),
    );
  }
}

class AddNewTask extends ConsumerStatefulWidget {
  final String projectId;
  const AddNewTask({super.key, required this.projectId});

  @override
  ConsumerState<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends ConsumerState<AddNewTask> {
  final _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: FractionallySizedBox(
        heightFactor: 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 5,
                width: 40,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Yeni Görev Ekle",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                InkWell(
                  child: Icon(Icons.close_rounded, color: Colors.grey.shade700),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              "Görev Açıklaması",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: "Örn: Not defterini kontrol et",
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
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0F6DF0),
                  ),
                  onPressed: () {
                    ref
                        .read(projectDetailProvider.notifier)
                        .createProjectTask(
                          widget.projectId,
                          _taskController.text,
                        );
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Görevi Oluştur",
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
    );
  }
}
