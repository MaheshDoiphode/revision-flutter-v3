import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'revision_record.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class User {
  @JsonKey(name: '_id', toJson: _objectIdToJson, fromJson: _objectIdFromJson)
  final ObjectId id;
  @JsonKey(name: 'userId')
  final String userId;
  @JsonKey(name: 'categories')
  final List<Category> categories;

  User({
    ObjectId? id,
    required this.userId,
    required this.categories,
  }) : id = id ?? ObjectId();

  // Use oid getter instead of deprecated toHexString
  static ObjectId _objectIdFromJson(Map<String, dynamic> json) => 
      ObjectId.fromHexString(json['\$oid'] as String);
  
  static Map<String, dynamic> _objectIdToJson(ObjectId objectId) => 
      { '\$oid': objectId.oid };

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class Category {
  @JsonKey(name: 'categoryName')
  final String categoryName;
  @JsonKey(name: 'subcategories')
  final List<Subcategory> subcategories;

  Category({
    required this.categoryName,
    required this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class Subcategory {
  @JsonKey(name: 'subcategoryName')
  final String subcategoryName;
  @JsonKey(name: 'topics')
  final List<Topic> topics;

  Subcategory({
    required this.subcategoryName,
    required this.topics,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => _$SubcategoryFromJson(json);
  Map<String, dynamic> toJson() => _$SubcategoryToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class Topic {
  @JsonKey(name: 'topicName')
  final String topicName;
  @JsonKey(name: 'notes')
  final String notes;
  @JsonKey(name: 'startDate', fromJson: DateTime.parse, toJson: _dateToString)
  final DateTime startDate;
  @JsonKey(name: 'revisionDates')
  final List<RevisionDate> revisionDates;

  Topic({
    required this.topicName,
    required this.notes,
    required this.startDate,
    required this.revisionDates,
  });

  static String _dateToString(DateTime date) => date.toIso8601String();

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}

@JsonSerializable(explicitToJson: true, anyMap: true)
class RevisionDate {
  @JsonKey(name: 'revisionNumber')
  final int revisionNumber;
  @JsonKey(name: 'revisionDate', fromJson: DateTime.parse, toJson: _dateToString)
  final DateTime revisionDate;
  @JsonKey(name: 'completed')
  bool completed;

  RevisionDate({
    required this.revisionNumber,
    required this.revisionDate,
    this.completed = false,
  });

  static String _dateToString(DateTime date) => date.toIso8601String();

  factory RevisionDate.fromJson(Map<String, dynamic> json) => _$RevisionDateFromJson(json);
  Map<String, dynamic> toJson() => _$RevisionDateToJson(this);
}

