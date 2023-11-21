import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:httpapp/main.dart';

void main() {
  testWidgets('Navigate between pages test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the initial page is the Home page.
    expect(find.text('NBA Teams'), findsOneWidget);

    // Verify that the Home page content is displayed.
    expect(find.text('Home'), findsOneWidget);

    // Tap the 'Search' tab in the BottomNavigationBar.
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    // Verify that the Search page content is displayed.
    expect(find.text('Search Teams'), findsOneWidget);

    // Tap the 'Profile' tab in the BottomNavigationBar.
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Verify that the Profile page content is displayed.
    expect(find.text('Profile'), findsOneWidget);
  });
}
