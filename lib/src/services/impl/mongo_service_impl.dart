import 'package:mongo_dart/mongo_dart.dart';
import 'package:revisionv2/src/services/mongo_service.dart';
import 'package:revisionv2/src/models/revision_record.dart';

class MongoServiceImpl implements IMongoService {
  static const String _connectionString = 'mongodb+srv://admin:1234@revision.j1dld.mongodb.net/?retryWrites=true&w=majority&appName=revision';
  static const String _dbName = 'revision-data';
  static const String _collection = 'users';
  
  Db? _db;
  bool get isConnected => _db?.state == State.open;
  
  @override
  Future<void> connect() async {
    try {
      _db = await Db.create(_connectionString);
      await _db!.open();
      
      if (!isConnected) {
        throw Exception('Failed to establish database connection');
      }
    } catch (e) {
      throw Exception('Database connection error: ${e.toString()}');
    }
  }

  @override
  Future<void> close() async {
    try {
      if (isConnected) {
        await _db?.close();
      }
    } catch (e) {
      throw Exception('Error closing database connection: ${e.toString()}');
    }
  }
  
  @override
  Future<User?> findUserById(String userId) async {
    if (!isConnected) throw Exception('Database connection not established');
    if (userId.isEmpty) throw ArgumentError('userId cannot be empty');

    try {
      final users = _db!.collection(_collection);
      final result = await users.findOne(where.eq('userId', userId));
      
      if (result == null) return null;
      
      return User.fromJson(result);
    } catch (e) {
      throw Exception('Error finding user: ${e.toString()}');
    }
  }

  @override
  Future<void> createNewUser(String userId) async {
    if (!isConnected) throw Exception('Database connection not established');
    if (userId.isEmpty) throw ArgumentError('userId cannot be empty');

    try {
      final exists = await checkUserExists(userId);
      if (exists) {
        throw Exception('User already exists');
      }

      final users = _db!.collection(_collection);
      // Create new user with just the basic structure
      await users.insertOne({
        'userId': userId,
        'categories': []
      });
    } catch (e) {
      throw Exception('Error creating new user: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkUserExists(String userId) async {
    if (!isConnected) throw Exception('Database connection not established');
    if (userId.isEmpty) throw ArgumentError('userId cannot be empty');

    try {
      final users = _db!.collection(_collection);
      final result = await users.findOne(where.eq('userId', userId));
      return result != null;
    } catch (e) {
      throw Exception('Error checking user existence: ${e.toString()}');
    }
  }
  
  @override
  Future<List<String>> fetchUserCategories(String userId) async {
    if (!isConnected) throw Exception('Database connection not established');
    if (userId.isEmpty) throw ArgumentError('userId cannot be empty');

    try {
      final users = _db!.collection(_collection);
      // Fetch only the categories array using projection
      final pipeline = AggregationPipelineBuilder()
          .addStage(Match(where.eq('userId', userId)))
          .addStage(Project({
            'categoryNames': '\$categories.categoryName',
            '_id': 0,
          }))
          .build();

      final result = await users.aggregateToStream(pipeline).toList();
      
      if (result.isEmpty) return [];
      
      // Extract category names from the result
      final categories = result.first['categoryNames'] as List;
      return categories.map((c) => c.toString()).toList();
    } catch (e) {
      throw Exception('Error fetching categories: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> fetchSubcategories(String userId, String categoryName) async {
    if (!isConnected) throw Exception('Database connection not established');
    if (userId.isEmpty) throw ArgumentError('userId cannot be empty');
    if (categoryName.isEmpty) throw ArgumentError('categoryName cannot be empty');

    try {
      final users = _db!.collection(_collection);
      // Use aggregation to efficiently fetch only the required subcategory names
      final pipeline = AggregationPipelineBuilder()
          .addStage(Match(where.eq('userId', userId)))
          .addStage(Unwind(const Field('categories')))
          .addStage(Match({
            'categories.categoryName': categoryName
          }))
          .addStage(Project({
            'subcategoryNames': '\$categories.subcategories.subcategoryName',
            '_id': 0,
          }))
          .build();

      final result = await users.aggregateToStream(pipeline).toList();
      
      if (result.isEmpty) return [];
      
      // Extract subcategory names from the result
      final subcategories = result.first['subcategoryNames'] as List;
      return subcategories.map((s) => s.toString()).toList();
    } catch (e) {
      throw Exception('Error fetching subcategories: ${e.toString()}');
    }
  }
  
}