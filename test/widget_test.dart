import 'package:flutter_test/flutter_test.dart';
import 'package:storage_hub/main.dart';

void main() {
  setUpAll(() async {
    // Hive needs to be initialized for tests too if used in mainApp or initial widgets
    // Mocking Hive is better, but for a simple "pumpWidget" test we might need basic setup.
    // However, Hive.initFlutter() uses path_provider which doesn't work effectively in unit tests without mocks.
    // For now, we will skip deep testing or just test basic rendering if possible.
    // To properly test this, we'd need to mock Hive.
  });

  testWidgets('App renders tabs smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Since main() does Hive.initFlutter(), we might face issues if we don't mock it.
    // But here we are importing StorageHubApp directly.
    // If StorageHubApp doesn't call Hive in build(), we might be okay.
    // But Hive.initFlutter is in main(), not StorageHubApp.

    await tester.pumpWidget(const StorageHubApp());

    // Verify that we see the SharedPrefs tab label
    expect(find.text('SharedPrefs'), findsOneWidget);
    expect(find.text('Hive'), findsOneWidget);
    expect(find.text('SQLite'), findsOneWidget);
    expect(find.text('File'), findsOneWidget);
  });
}
