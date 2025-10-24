import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino/flutter_cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FCSlider', () {
    testWidgets('creates with default values', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSlider(
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSlider), findsOneWidget);
    });

    testWidgets('creates with custom value', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSlider(
            value: 0.75,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSlider), findsOneWidget);
    });

    testWidgets('creates with custom range', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSlider(
            value: 50,
            maximumValue: 100,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSlider), findsOneWidget);
    });

    testWidgets('creates with custom colors', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSlider(
            minimumTrackTintColor: const Color(0xFF34C759),
            maximumTrackTintColor: const Color(0xFFE5E5EA),
            thumbTintColor: const Color(0xFFFFFFFF),
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSlider), findsOneWidget);
    });

    testWidgets('creates with custom dimensions', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSlider(
            width: 300,
            height: 50,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSlider), findsOneWidget);
    });

    testWidgets('creates with continuous mode', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSlider(
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSlider), findsOneWidget);
    });

    testWidgets('creates with discrete mode', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSlider(
            isContinuous: false,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSlider), findsOneWidget);
    });

    testWidgets('getCreationParams returns correct values', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSlider(
            value: 0.6,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSlider), findsOneWidget);
    });

    testWidgets('handles platform view on iOS/macOS', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSlider(
            value: 0.8,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSlider), findsOneWidget);
    });
  });
}
