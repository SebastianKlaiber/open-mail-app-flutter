import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Mail App Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Open Mail App'),
              onPressed: () async {
                // Android: Will open mail app or show native picker.
                // iOS: Will open mail app if single mail app found.
                final result = await OpenMailApp.openMailApp(
                  nativePickerTitle: 'Select email app to open',
                );

                // If no mail apps found, show error
                if (!result.didOpen && !result.canOpen) {
                  if (context.mounted) {
                    showNoMailAppsDialog(context);
                  }

                  // iOS: if multiple mail apps found, show dialog to select.
                  // There is no native intent/default app system in iOS so
                  // you have to do it yourself.
                } else if (!result.didOpen && result.canOpen) {
                  if (context.mounted) {
                    await showDialog<void>(
                      context: context,
                      builder: (_) {
                        return MailAppPickerDialog(
                          mailApps: result.options,
                        );
                      },
                    );
                  }
                }
              },
            ),
            ElevatedButton(
              child: const Text('Open mail app, with email already composed'),
              onPressed: () async {
                final email = EmailContent(
                  to: [
                    'user@domain.com',
                  ],
                  subject: 'Hello!',
                  body: 'How are you doing?',
                  cc: ['user2@domain.com', 'user3@domain.com'],
                  bcc: ['boss@domain.com'],
                );

                final result = await OpenMailApp.composeNewEmailInMailApp(
                  nativePickerTitle: 'Select email app to compose',
                  emailContent: email,
                );
                if (!result.didOpen && !result.canOpen) {
                  if (context.mounted) {
                    showNoMailAppsDialog(context);
                  }
                } else if (!result.didOpen && result.canOpen) {
                  if (context.mounted) {
                    await showDialog<void>(
                      context: context,
                      builder: (_) => MailAppPickerDialog(
                        mailApps: result.options,
                        emailContent: email,
                      ),
                    );
                  }
                }
              },
            ),
            ElevatedButton(
              child: const Text('Get Mail Apps'),
              onPressed: () async {
                final apps = await OpenMailApp.getMailApps();

                if (apps.isEmpty) {
                  if (context.mounted) {
                    showNoMailAppsDialog(context);
                  }
                } else {
                  if (context.mounted) {
                    await showDialog<void>(
                      context: context,
                      builder: (context) {
                        return MailAppPickerDialog(
                          mailApps: apps,
                          emailContent: EmailContent(
                            to: [
                              'user@domain.com',
                            ],
                            subject: 'Hello!',
                            body: 'How are you doing?',
                            cc: ['user2@domain.com', 'user3@domain.com'],
                            bcc: ['boss@domain.com'],
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Open Mail App'),
          content: const Text('No mail apps installed'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
