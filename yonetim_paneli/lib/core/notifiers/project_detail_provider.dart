import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yonetim_paneli/core/models/task.model.dart';
import 'package:yonetim_paneli/core/notifiers.dart';
import 'package:yonetim_paneli/core/services/project_service.dart';

class ProjectDetailNotifier extends AsyncNotifier<ProjectDetail?> {
  @override
  FutureOr<ProjectDetail?> build() {
    return null;
  }

  Future<void> loadDetails(String projectId) async {
    state = AsyncLoading();
    final projectData = await ProjectService.getProjectDetail(projectId);
    state = AsyncData(projectData);
    if (projectData != null) {
      ref
          .read(projectProvider.notifier)
          .updateProgress(projectId, projectData.progress);
    }
  }

  Future<void> createProjectTask(String projectId, String description) async {
    state = AsyncLoading();
    await ProjectService.createProjectTask(
      projectId: projectId,
      description: description,
    );
    await loadDetails(projectId);
  }

  Future<void> updateProjectTask(
    String taskId,
    int value,
    String projectId,
  ) async {
    state = AsyncLoading();
    await ProjectService.updateProjectTask(taskId: taskId, value: value);
    await loadDetails(projectId);
  }

  Future<void> deleteProjectTask(String taskId, String projectId) async {
    state = AsyncLoading();
    await ProjectService.deleteProjectTask(taskId: taskId);
    await loadDetails(projectId);
  }
}
