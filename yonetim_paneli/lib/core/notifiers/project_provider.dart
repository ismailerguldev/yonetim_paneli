import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yonetim_paneli/core/models/project.model.dart';
import 'package:yonetim_paneli/core/services/project_service.dart';

class ProjectNotifier extends AsyncNotifier<List<Project>?> {
  @override
  FutureOr<List<Project>?> build() async {
    return await ProjectService.getProjects();
  }

  Future<void> addProject(Map<String, dynamic> projectData) async {
    await ProjectService.createProject(
      name: projectData['name'],
      description: projectData['description'],
      priority: projectData['priority'],
      endDate: projectData['end_date'],
    );
    ref.invalidateSelf();
  }

  Future<void> removeProject(String projectId) async {
    await ProjectService.removeProject(projectId);
    ref.invalidateSelf();
  }
  void updateProgress(String projectId, int progressx) {
    final currentList = state.value;
    if (currentList != null) {
      final updatedList = currentList.map((element) {
        if (element.id == projectId) {
          return element.copyWith(progressx: progressx);
        }
        return element;
      }).toList();
      state = AsyncData(updatedList);
    }
  }
}
