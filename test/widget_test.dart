import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tiny_pop/main.dart';
import 'package:tiny_pop/widgets/gift_box.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const TinyPopApp());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> _startGame(WidgetTester tester) async {
  await _pumpApp(tester);
  await tester.tap(find.text('Play'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _pumpGameFrame(WidgetTester tester, [Duration duration = const Duration(milliseconds: 250)]) async {
  await tester.pump();
  await tester.pump(duration);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Main menu shows title and Play button', (WidgetTester tester) async {
    await _pumpApp(tester);

    expect(find.text('Tiny Pop'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);
    expect(find.text('Best Score: 0'), findsOneWidget);
    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
    expect(find.text('Time: 60'), findsNothing);
    expect(find.text('🎁'), findsOneWidget);
  });

  testWidgets('Sound toggle turns sound off on main menu', (WidgetTester tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byIcon(Icons.volume_up_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
  });

  testWidgets('Sound setting persists on relaunch', (WidgetTester tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byIcon(Icons.volume_up_rounded));
    await tester.pump();

    await _pumpApp(tester);

    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
  });

  testWidgets('Sound setting loads from storage on startup', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'sound_enabled': false});

    await _pumpApp(tester);

    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
  });

  testWidgets('Sound toggle is available during gameplay', (WidgetTester tester) async {
    await _startGame(tester);

    expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.volume_up_rounded));
    await tester.pump();

    expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
  });

  testWidgets('Game starts after Play is tapped', (WidgetTester tester) async {
    await _startGame(tester);

    expect(find.text('Score: 0'), findsOneWidget);
    expect(find.text('Time: 60'), findsOneWidget);
    expect(find.text('Play'), findsNothing);
  });

  testWidgets('Score increments when the gift is tapped', (WidgetTester tester) async {
    await _startGame(tester);

    await tester.tap(find.byKey(GiftBox.tapKey));
    await _pumpGameFrame(tester);

    expect(find.text('Score: 1'), findsOneWidget);
  });

  testWidgets('Timer counts down every second', (WidgetTester tester) async {
    await _startGame(tester);

    expect(find.text('Time: 60'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Time: 59'), findsOneWidget);
  });

  testWidgets('Game over panel appears when time runs out', (WidgetTester tester) async {
    await _startGame(tester);

    await tester.pump(const Duration(seconds: 60));
    await tester.pump();

    expect(find.text('Game Over'), findsOneWidget);
    expect(find.text('Play Again'), findsOneWidget);
  });

  testWidgets('Play Again resets the game', (WidgetTester tester) async {
    await _startGame(tester);

    await tester.tap(find.byKey(GiftBox.tapKey));
    await _pumpGameFrame(tester);
    await tester.pump(const Duration(seconds: 60));
    await tester.pump();

    expect(find.text('Final Score: 1'), findsOneWidget);
    expect(find.text('Best Score: 1'), findsOneWidget);
    expect(find.text('New Record!'), findsOneWidget);

    await tester.tap(find.text('Play Again'));
    await _pumpGameFrame(tester);

    expect(find.text('Score: 0'), findsOneWidget);
    expect(find.text('Time: 60'), findsOneWidget);
    expect(find.text('Game Over'), findsNothing);
    expect(find.byKey(GiftBox.tapKey), findsOneWidget);
  });
}
