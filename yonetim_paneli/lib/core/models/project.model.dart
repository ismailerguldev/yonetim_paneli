class Project {
  final String id;
  final String name;
  final String? description;
  final DateTime endDate;
  final String priority;
  final int progress;
  Project({
    required this.id,
    required this.name,
    required this.endDate,
    required this.priority,
    this.description,
    required this.progress,
  });
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json["id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "İSimsiz Proje",
      description: json["description"]?.toString(),
      endDate: json["endDate"] != null
          ? DateTime.tryParse(json["endDate"].toString()) ?? DateTime.now()
          : DateTime.now(),
      priority: json["priority"]?.toString() ?? "yok",
      progress: json["progress"] != null
          ? int.tryParse(json["progress"].toString()) ?? 0
          : 0,
    );
  }
  Project copyWith({required int progressx}) {
    return Project(
      id: id,
      name: name,
      endDate: endDate,
      priority: priority,
      progress: progressx,
    );
  }
}
