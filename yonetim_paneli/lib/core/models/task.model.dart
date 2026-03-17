class ProjectTask {
  final String id;
  final String taskDescription;
  final bool isDone;
  ProjectTask({required this.id, required this.taskDescription, required this.isDone});

  factory ProjectTask.fromJson(Map<String, dynamic> json) {
    return ProjectTask(
      id: json["id"]?.toString() ?? '',
      taskDescription: json["description"]?.toString() ?? '',
      isDone: json["isDone"] == 1 || json["isDone"] == true,
    );
  }
}

class ProjectDetail {
  final String description;
  final List<ProjectTask> tasks;
  final int progress;
  ProjectDetail({required this.description, required this.tasks, required this.progress});
}
