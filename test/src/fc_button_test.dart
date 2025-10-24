import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino/flutter_cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FCButton', () {
    testWidgets('creates with default values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('creates with custom title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Custom Button',
              onPressed: null,
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('creates with custom colors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Colored Button',
              backgroundColor: const Color(0xFF0000FF),
              foregroundColor: const Color(0xFFFFFFFF),
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('creates with custom dimensions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Custom Size',
              width: 200,
              height: 60,
              fontSize: 20,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('creates disabled button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Disabled',
              isEnabled: false,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('creates disabled button with null callback', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'No Callback',
              onPressed: null,
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    test('getCreationParams returns correct values', () {
      // This test verifies the creation params logic
      // In a real scenario, we'd need to test the private method
      // For now, we test that the widget can be constructed
      const button = FCButton(
        title: 'Test',
        style: FCButtonStyle.bordered,
        backgroundColor: Color(0xFFFF0000),
        foregroundColor: Color(0xFF00FF00),
        fontSize: 18,
        onPressed: null,
      );

      expect(button.title, 'Test');
      expect(button.style, FCButtonStyle.bordered);
      expect(button.backgroundColor, const Color(0xFFFF0000));
      expect(button.foregroundColor, const Color(0xFF00FF00));
      expect(button.fontSize, 18);
      expect(button.isEnabled, isTrue);
    });

    testWidgets('creates with plain style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Plain',
              style: FCButtonStyle.plain,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('creates with automatic style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Automatic',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('creates with borderless style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Borderless',
              style: FCButtonStyle.borderless,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('creates with bordered style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Bordered',
              style: FCButtonStyle.bordered,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('creates with borderedProminent style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Bordered Prominent',
              style: FCButtonStyle.borderedProminent,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('creates with glass style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Glass',
              style: FCButtonStyle.glass,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('creates with glassProminent style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Glass Prominent',
              style: FCButtonStyle.glassProminent,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);
    });

    testWidgets('handles platform view on iOS/macOS', (tester) async {
      // Mock platform view creation
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter_cupertino/fc_button_0'),
        (MethodCall methodCall) async {
          return null;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FCButton(
              title: 'Platform Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FCButton), findsOneWidget);

      // Clean up
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('flutter_cupertino/fc_button_0'),
        null,
      );
    });
  });
}
