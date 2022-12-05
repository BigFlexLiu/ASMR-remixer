import 'package:asmr_maker/components/common_widgets.dart';
import 'package:asmr_maker/pages/remix_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/remix_components.dart';
import '../providers/remix.dart';
import '../providers/remixes.dart';
import '../providers/sound_clips.dart';

class RemixPage extends StatefulWidget {
  RemixPage({super.key});

  @override
  State<RemixPage> createState() => _RemixPageState();
}

class _RemixPageState extends State<RemixPage> {
  String newRemixName = "";
  late BuildContext bottomContext;

  @override
  Widget build(BuildContext context) {
    bottomContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Remixes'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add remix',
              onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Give your remix a name'),
                        content: TextField(
                          decoration: InputDecoration(
                              labelText: newRemixName, hintText: 'unnamed'),
                          onChanged: (value) {
                            setState(() {
                              newRemixName = value;
                            });
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                newRemixName = "";
                              });
                              Navigator.pop(context, 'Cancel');
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Remix newRemix = Remix()..name = newRemixName;
                              Navigator.pop(context, 'OK');
                              context.read<Remixes>().addRemix(newRemix);
                              context.read<SoundClips>().remix = newRemix;

                              Navigator.push(
                                  bottomContext,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RemixSettings(newRemix))).then(
                                  (value) => bottomContext
                                      .read<SoundClips>()
                                      .remix = null);
                            },
                            child: const Text('Done'),
                          ),
                        ],
                      ),
                    ),
                  }),
        ],
      ),
      body: const RemixList(),
    );
  }
}
