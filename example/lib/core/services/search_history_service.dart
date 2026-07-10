/// Local storage service for search history.
abstract class SearchHistoryService {
  static void add(String key, String query) {}
  static List<String> getHistory(String key) => [];
  static void clear(String key) {}
}
