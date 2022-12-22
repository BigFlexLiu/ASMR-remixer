import 'package:asmr_maker/components/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';

import '../providers/settings.dart';

class ThemeSelection extends StatefulWidget {
  const ThemeSelection({super.key});

  @override
  State<ThemeSelection> createState() => _ThemeSelectionState();
}

class _ThemeSelectionState extends State<ThemeSelection> {
  final themes = ["system", "light", "dark"];
  String themeMode = "system";
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
          groupValue: themeMode,
          onChanged: (value) {
            context.read<Settings>().theme = ThemeMode.values
                .firstWhere((element) => element.name == value!);
            setState(() {
              themeMode = value!;
            });
          },
          items: themes,
          itemBuilder: (value) => RadioButtonBuilder(value),
        ),
      ],
    );
  }
}

class ContactMe extends StatelessWidget {
  const ContactMe({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
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
      onPressed: () {},
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
