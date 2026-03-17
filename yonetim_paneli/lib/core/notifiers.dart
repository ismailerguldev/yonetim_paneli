import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yonetim_paneli/core/models/project.model.dart';
import 'package:yonetim_paneli/core/models/task.model.dart';
import 'package:yonetim_paneli/core/models/user.model.dart';
import 'package:yonetim_paneli/core/notifiers/auth_provider.dart';
import 'package:yonetim_paneli/core/notifiers/project_detail_provider.dart';
import 'package:yonetim_paneli/core/notifiers/project_provider.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});
final projectProvider = AsyncNotifierProvider<ProjectNotifier, List<Project>?>(
  () {
    return ProjectNotifier();
  },
);
final projectDetailProvider =
    AsyncNotifierProvider<ProjectDetailNotifier, ProjectDetail?>(() {
      return ProjectDetailNotifier();
    });
