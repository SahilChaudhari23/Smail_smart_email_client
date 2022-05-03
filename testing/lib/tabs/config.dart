import 'package:flutter/material.dart';
import 'package:testing/tabs/frontpage.dart';
import 'package:testing/tabs/addTag.dart';
import 'package:testing/tabs/editTag.dart';

class Config extends StatefulWidget {
  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg1.jpg"),
                    fit: BoxFit.cover,
                    opacity: 0.2,
                  ),
                ),
                padding: EdgeInsets.only(top: 60),
                child: Column(
                  children: <Widget>[
                    ExpansionTile(
                      title: Text(
                        'Add Tag',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Create new tag for labeller'),
                      trailing: Icon(
                        _customTileExpanded
                            ? Icons.arrow_drop_down_circle
                            : Icons.arrow_drop_down,
                      ),
                      children: <Widget>[
                        ListTile(
                          title: Text('Click here to Create Tag'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => addTag()),
                            );
                          },
                        ),
                      ],
                      onExpansionChanged: (bool expanded) {
                        setState(() => _customTileExpanded = expanded);
                      },
                    ),
                    ExpansionTile(
                      title: const Text(
                        'Config Tag',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Edit pre-existing tag'),
                      children: List.generate(gmailMessage.priorityHandler.tagList.length, (i) {
                        return ListTile(
                          title: Text(gmailMessage.priorityHandler.tagList[i].name),
                          tileColor: gmailMessage.priorityHandler.pNumMap[gmailMessage.priorityHandler.tagList[i].priorityNum],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => editTag(gmailMessage.priorityHandler.tagList[i].name)),
                            );
                          },
                        );
                      }),
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: ElevatedButton(
                          child: Text('Refresh'),
                          onPressed: () {
                            (context as Element).reassemble();
                          },
                        )
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
