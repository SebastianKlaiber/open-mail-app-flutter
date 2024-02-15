import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:platform/platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('open_mail_app');
  final log = <MethodCall>[];

  tearDown(log.clear);

  testWidgets('openMailApp Android', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      log.add(call);
      if (call.method == 'openMailApp') {
        return true;
      }
      return null;
    });

    OpenMailApp.platform = FakePlatform(operatingSystem: Platform.android);
    final result = await OpenMailApp.openMailApp();
    expect(result.didOpen, true);
    expect(
      log,
      <Matcher>[
        isMethodCall('openMailApp', arguments: {'nativePickerTitle': ''}),
      ],
    );
  });
}
