// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revision_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) => User(
      id: User._objectIdFromJson(json['_id'] as Map<String, dynamic>),
      userId: json['userId'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': User._objectIdToJson(instance.id),
      'userId': instance.userId,
      'categories': instance.categories.map((e) => e.toJson()).toList(),
    };

Category _$CategoryFromJson(Map json) => Category(
      categoryName: json['categoryName'] as String,
      subcategories: (json['subcategories'] as List<dynamic>)
          .map((e) => Subcategory.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'categoryName': instance.categoryName,
      'subcategories': instance.subcategories.map((e) => e.toJson()).toList(),
    };

Subcategory _$SubcategoryFromJson(Map json) => Subcategory(
      subcategoryName: json['subcategoryName'] as String,
      topics: (json['topics'] as List<dynamic>)
          .map((e) => Topic.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$SubcategoryToJson(Subcategory instance) =>
    <String, dynamic>{
      'subcategoryName': instance.subcategoryName,
      'topics': instance.topics.map((e) => e.toJson()).toList(),
    };

Topic _$TopicFromJson(Map json) => Topic(
      topicName: json['topicName'] as String,
      notes: json['notes'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      revisionDates: (json['revisionDates'] as List<dynamic>)
          .map(
              (e) => RevisionDate.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'topicName': instance.topicName,
      'notes': instance.notes,
      'startDate': Topic._dateToString(instance.startDate),
      'revisionDates': instance.revisionDates.map((e) => e.toJson()).toList(),
    };

RevisionDate _$RevisionDateFromJson(Map json) => RevisionDate(
      revisionNumber: (json['revisionNumber'] as num).toInt(),
      revisionDate: DateTime.parse(json['revisionDate'] as String),
      completed: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$RevisionDateToJson(RevisionDate instance) =>
    <String, dynamic>{
      'revisionNumber': instance.revisionNumber,
      'revisionDate': RevisionDate._dateToString(instance.revisionDate),
      'completed': instance.completed,
    };
