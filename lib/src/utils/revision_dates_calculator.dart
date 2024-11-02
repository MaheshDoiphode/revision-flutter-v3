import '../models/revision_record.dart';

class RevisionDatesCalculator {
  /// Generates revision dates following the algorithm:
  /// 1. First revision: within 24 hours of start
  /// 2. Second revision: 3 days after start
  /// 3. Third revision: 7 days after second revision
  /// 4. Fourth revision: 7 days after third revision
  /// 5. Fifth revision: 7 days after fourth revision
  /// 6. Sixth revision: 60 days after fifth revision
  /// 7. Seventh revision: 4 months after sixth revision
  static List<RevisionDate> calculateRevisionDates(DateTime startDate) {
    final List<RevisionDate> revisionDates = [];
    DateTime previousDate = startDate;

    // First revision: Next day
    final firstRevision = RevisionDate(
      revisionNumber: 1,
      revisionDate: startDate.add(const Duration(days: 1)),
      completed: false,
    );
    revisionDates.add(firstRevision);
    previousDate = startDate; // Starting point for second revision

    // Second revision: 3 days after start
    final secondRevision = RevisionDate(
      revisionNumber: 2,
      revisionDate: previousDate.add(const Duration(days: 3)),
      completed: false,
    );
    revisionDates.add(secondRevision);
    previousDate = secondRevision.revisionDate;

    // Third revision: 7 days after second revision
    final thirdRevision = RevisionDate(
      revisionNumber: 3,
      revisionDate: previousDate.add(const Duration(days: 7)),
      completed: false,
    );
    revisionDates.add(thirdRevision);
    previousDate = thirdRevision.revisionDate;

    // Fourth revision: 7 days after third revision
    final fourthRevision = RevisionDate(
      revisionNumber: 4,
      revisionDate: previousDate.add(const Duration(days: 7)),
      completed: false,
    );
    revisionDates.add(fourthRevision);
    previousDate = fourthRevision.revisionDate;

    // Fifth revision: 7 days after fourth revision
    final fifthRevision = RevisionDate(
      revisionNumber: 5,
      revisionDate: previousDate.add(const Duration(days: 7)),
      completed: false,
    );
    revisionDates.add(fifthRevision);
    previousDate = fifthRevision.revisionDate;

    // Sixth revision: 60 days after fifth revision
    final sixthRevision = RevisionDate(
      revisionNumber: 6,
      revisionDate: previousDate.add(const Duration(days: 60)),
      completed: false,
    );
    revisionDates.add(sixthRevision);
    previousDate = sixthRevision.revisionDate;

    // Seventh revision: ~4 months (120 days) after sixth revision
    final seventhRevision = RevisionDate(
      revisionNumber: 7,
      revisionDate: previousDate.add(const Duration(days: 120)),
      completed: false,
    );
    revisionDates.add(seventhRevision);

    return revisionDates;
  }

  /// Helper method to create a new Topic with calculated revision dates
  static Topic createTopicWithDates({
    required String topicName,
    required String notes,
    DateTime? startDate,
  }) {
    final start = startDate ?? DateTime.now();
    return Topic(
      topicName: topicName,
      notes: notes,
      startDate: start,
      revisionDates: calculateRevisionDates(start),
    );
  }
}