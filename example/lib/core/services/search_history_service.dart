import 'package:example/core/services/storage_service.dart';

/// Local storage service for search history.
abstract class SearchHistoryService {
  static void add(String key, String query) {
    if (query.trim().isEmpty) return;
    final storage = StorageService.find;
    final history = storage.getStringList(key);
    if (!history.contains(query)) {
      history.insert(0, query);
      // Keep only last 10 entries
      if (history.length > 10) history.removeLast();
      storage.setStringList(key, history);
    }
  }

  static List<String> getHistory(String key) {
    final storage = StorageService.find;
    return storage.getStringList(key);
  }

  static void clear(String key) {
    final storage = StorageService.find;
    storage.remove(key);
  }
}
