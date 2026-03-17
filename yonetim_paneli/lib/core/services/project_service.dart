import 'package:dio/dio.dart';
import 'package:yonetim_paneli/core/models/project.model.dart';
import 'package:yonetim_paneli/core/models/task.model.dart';
import 'package:yonetim_paneli/core/services/fetch_service.dart';

class ProjectService {
  static Future<void> createProject({
    required String name,
    required String description,
    required String priority,
    required String endDate,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        "/project/create",
        data: {
          "name": name,
          "description": description,
          "priority": priority,
          "end_date": endDate,
        },
      );
    } on DioException catch (e) {
      print(e.response?.data.toString());
    }
  }

  static Future<List<Project>> getProjects() async {
    print("bura çalışıyo otomatik");
    try {
      final response = await ApiClient.dio.get("/project/get");
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> data = responseData["projects"];
      return data.map((json) => Project.fromJson(json)).toList();
    } on DioException catch (e) {
      print(e.response?.data.toString());
      return [];
    }
  }

  static Future<ProjectDetail?> getProjectDetail(String projectId) async {
    try {
      final response = await ApiClient.dio.get(
        "/project/get/detail",
        queryParameters: {"projectId": projectId},
      );
      final responseData = response.data;
      final List<ProjectTask> tasks = responseData["project"]["tasks"]
          .map<ProjectTask>((task) => ProjectTask.fromJson(task))
          .toList();
      final ProjectDetail projectData = ProjectDetail(
        description: responseData["project"]["description"],
        tasks: tasks,
        progress: responseData["project"]["progress"],
      );
      return projectData;
    } on DioException catch (e) {
      print(e.response?.data.toString());
      return null;
    }
  }

  static Future<void> removeProject(String projectId) async {
    try {
      await ApiClient.dio.put(
        "/project/remove",
        data: {"projectId": projectId},
      );
    } on DioException catch (e) {
      print(e.response?.data.toString());
    }
  }

  static Future<void> createProjectTask({
    required String projectId,
    required String description,
  }) async {
    try {
      await ApiClient.dio.post(
        "/project/create/task",
        data: {
          "task": {"project_id": projectId, "description": description},
        },
      );
    } on DioException catch (e) {
      print(e.response?.data.toString());
    }
  }

  static Future<void> updateProjectTask({
    required String taskId,
    required int value,
  }) async {
    try {
      await ApiClient.dio.put(
        "/project/task/update",
        data: {"taskId": taskId, "value": value},
      );
    } on DioException catch (e) {
      print(e.response?.data.toString());
    }
  }

  static Future<void> deleteProjectTask({required String taskId}) async {
    try {
      await ApiClient.dio.delete(
        "/project/task/delete",
        data: {"taskId": taskId},
      );
    } on DioException catch (e) {
      print(e.response?.data.toString());
    }
  }
}
