import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yonetim_paneli/core/models/project.model.dart';
import 'package:yonetim_paneli/core/notifiers.dart';

class ProjectCard extends ConsumerWidget {
  final String name;
  final int progress;
  final String priority;
  final DateTime endDate;
  final String id;
  const ProjectCard({
    super.key,
    required this.name,
    required this.endDate,
    required this.progress,
    required this.priority,
    required this.id,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(projectDetailProvider.notifier).loadDetails(id);
        final Project project = Project(
          id: id,
          name: name,
          endDate: endDate,
          priority: priority,
          progress: progress,
        );
        context.push("/project/$id", extra: project);
      },
      child: Container(
        decoration: BoxDecoration(
          border: BoxBorder.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x13000000),
              blurRadius: 15,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        width: 300,
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F6DF0), Color(0xFF0A4ABA)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.rocket, color: Colors.white, size: 28),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(14, 2, 14, 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    priority,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${endDate.day}.${endDate.month}.${endDate.year} - ${endDate.hour}:${endDate.minute} tarihine kadar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("İlerleme"), Text("%$progress")],
                ),
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF0A4ABA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
