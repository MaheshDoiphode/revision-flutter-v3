import '../models/revision_record.dart';

abstract class IMongoService {
  /// Connection management
  Future<void> connect();
  Future<void> close();

  /// User operations
  Future<User?> findUserById(String userId);
  Future<void> createNewUser(String userId);
  Future<bool> checkUserExists(String userId);

  /// Category operations
  Future<List<String>> fetchUserCategories(String userId);
  Future<List<String>> fetchSubcategories(String userId, String categoryName);

  // /// Category management
  // Future<void> createCategory(String userId, String categoryName);
  // Future<void> createSubcategory(String userId, String categoryName, String subcategoryName);

  // /// Topic operations
  // Future<void> insertTopic({
  //   required String userId,
  //   required String categoryName,
  //   required String subcategoryName,
  //   required Topic topic,
  // });

  // /// Revision operations
  // Future<List<Topic>> fetchTodaysRevisions(String userId);
  // Future<List<Map<String, dynamic>>> fetchPendingRevisions(String userId);
  
  // Future<void> completeRevision({
  //   required String userId,
  //   required String categoryName,
  //   required String subcategoryName,
  //   required String topicName,
  //   required int revisionNumber,
  // });

  // Future<void> updateRevisionStatus({
  //   required String userId,
  //   required String categoryName,
  //   required String subcategoryName,
  //   required String topicName,
  //   required int revisionNumber,
  //   required bool completed,
  // });
}
