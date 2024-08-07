import 'package:event_planner/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:event_planner/models/event_model.dart';

// Mock class for Hive box
class MockBox<T> extends Mock implements Box<T> {}

void main() {
  setUpAll(() {
    registerFallbackValue(Event(
      title: '',
      date: DateTime.now(),
      location: '',
      description: '',
      isAttending: false
    ));
  });
  group('Event Service Tests', () {
    late MockBox<Event> mockEventBox;
    late DashboardState dashboardState;
    
    setUp(() {
      mockEventBox = MockBox<Event>();
      final dashboard = Dashboard(testEventBox: mockEventBox);
      dashboardState = dashboard.createState();
      dashboardState.eventBox = mockEventBox;
    });

    test('Add Event', () async {
      final event = Event(
        title: 'Test Event',
        description: 'This is a test event',
        date: DateTime.now(),
        location: 'Test Location',
        isAttending: false
      );

      when(() => mockEventBox.add(event)).thenAnswer((_) async => 1);
      await dashboardState.addEvent(event);
      verify(() => mockEventBox.add(event)).called(1);
    });

    test('Edit Event', () {
      final event = Event(
        title: 'Updated Event',
        description: 'Updated description',
        date: DateTime.now(),
        location: 'Updated Location',
        isAttending: true
      );

      when(() => mockEventBox.putAt(0, event)).thenAnswer((_) async {});
      dashboardState.updateEvent(0, event);
      verify(() => mockEventBox.putAt(0, event)).called(1);
    });

    test('Delete Event', () {
      when(() => mockEventBox.deleteAt(0)).thenAnswer((_) async {});
      dashboardState.deleteEvent(0);
      verify(() => mockEventBox.deleteAt(0)).called(1);
    });
  });
}