import 'task_api_service.dart';
import 'TaskLocalDatabase.dart';
class TaskSyncService {
  static Future<void> loadInitialDataIfNeeded() async {
// jeżeli lokalna baza ma już dane to nie pobieramy niczego
    if (!TaskLocalDatabase.isEmpty()) {
      return;
    }
    final tasks = await TaskApiService.fetchTasks();
    await TaskLocalDatabase.saveTasks(tasks);
  }
}
