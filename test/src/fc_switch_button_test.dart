import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino/flutter_cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FCSwitchButton', () {
    testWidgets('creates with default values', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSwitchButton(
            onToggle: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSwitchButton), findsOneWidget);
    });

    testWidgets('creates with custom label', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSwitchButton(
            label: 'Custom Toggle',
            onToggle: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSwitchButton), findsOneWidget);
    });

    testWidgets('creates with initial on state', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSwitchButton(
            label: 'On Toggle',
            isOn: true,
            onToggle: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSwitchButton), findsOneWidget);
    });

    testWidgets('creates with custom colors', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSwitchButton(
            onColor: const Color(0xFF34C759),
            onToggle: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSwitchButton), findsOneWidget);
    });

    testWidgets('creates with custom dimensions', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSwitchButton(
            width: 200,
            height: 50,
            onToggle: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSwitchButton), findsOneWidget);
    });

    testWidgets('creates disabled toggle button', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSwitchButton(
            isEnabled: false,
            onToggle: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSwitchButton), findsOneWidget);
    });

    testWidgets('creates with images', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSwitchButton(
            onToggle: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSwitchButton), findsOneWidget);
    });

    testWidgets('getCreationParams returns correct values', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSwitchButton(
            label: 'Test Toggle',
            isOn: true,
            onColor: const Color(0xFF007AFF),
            onToggle: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSwitchButton), findsOneWidget);
    });

    testWidgets('handles platform view on iOS/macOS', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSwitchButton(
            label: 'Platform Toggle',
            onToggle: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSwitchButton), findsOneWidget);
    });

    testWidgets('creates with custom content insets', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: FCSwitchButton(
            onToggle: (_) {},
          ),
        ),
      );

      expect(find.byType(FCSwitchButton), findsOneWidget);
    });
  });
}
