import 'package:asmr_maker/components/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:provider/provider.dart';
import 'package:launch_review/launch_review.dart';

import '../providers/settings.dart';

class ThemeSelection extends StatefulWidget {
  const ThemeSelection({super.key});

  @override
  State<ThemeSelection> createState() => _ThemeSelectionState();
}

class _ThemeSelectionState extends State<ThemeSelection> {
  final themes = ThemeMode.values.map((e) => e.name).toList();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonPadding(
          child: Text(
            "Theme",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        RadioGroup.builder(
          direction: Axis.horizontal,
          groupValue: context.watch<Settings>().theme.name,
          onChanged: (value) {
            context.read<Settings>().theme = ThemeMode.values
                .firstWhere((element) => element.name == value!);
          },
          items: themes,
          itemBuilder: (value) => RadioButtonBuilder(value),
        ),
      ],
    );
  }
}

class ContactMe extends StatefulWidget {
  const ContactMe({super.key});

  @override
  State<ContactMe> createState() => _ContactMeState();
}

class _ContactMeState extends State<ContactMe> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        EmailContent email = EmailContent(
          to: [
            'cfastapps@email.com',
          ],
          subject: 'Hello!',
          body: 'How are you doing?',
        );

        OpenMailAppResult result = await OpenMailApp.composeNewEmailInMailApp(
            nativePickerTitle: 'Select email app to compose',
            emailContent: email);
        if (!result.didOpen && !result.canOpen) {
          if (!mounted) return;
          showNoMailAppsDialog(context);
        } else if (!result.didOpen && result.canOpen) {
          showDialog(
            context: context,
            builder: (_) => MailAppPickerDialog(
              mailApps: result.options,
              emailContent: email,
            ),
          );
        }
      },
      label: const Text("Contact me"),
      icon: const Icon(Icons.email_outlined),
    );
  }
}

class RateMe extends StatelessWidget {
  const RateMe({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => LaunchReview.launch(),
      label: const Text("Rate me"),
      icon: const Icon(Icons.rate_review),
    );
  }
}

class FindMe extends StatelessWidget {
  const FindMe({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      label: const Text("Find me"),
      icon: const Icon(Icons.discord),
    );
  }
}

class CommonPadding extends StatelessWidget {
  CommonPadding({this.child, super.key});
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0), child: child);
  }
}

void showNoMailAppsDialog(BuildContext context, [bool mounted = true]) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Open Mail App"),
        content: Text("No mail apps installed"),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
