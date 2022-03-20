import 'package:flutter/material.dart';
import 'package:testing/tabs/frontpage.dart';

class Drawers extends StatefulWidget {

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
          padding: const EdgeInsets.fromLTRB(20, 50, 0, 10),
          decoration: BoxDecoration(
            color: Colors.deepOrange[400],
          ),
          width: MediaQuery.of(context).size.width * 0.45,
            height: 200.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo.png'),
                    radius: 50.0,
                  ),
                const Text(
                  '  Smail',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cinzel',
                    fontSize: 50.0,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.white38,
                        offset: Offset(5.0, 7.0),
                      ),
                    ],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            ),
            ),
          Divider(),
          ListTile(
            leading: Icon(Icons.filter),
            title: Text('All inboxes'),
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('Inbox'),
          ),
          ListTile(
            leading: Icon(Icons.label_important_outline),
            title: Text('Important'),
          ),
          ListTile(
            leading: Text('ALL LABELS'),
          ),
          ListTile(
            leading: Icon(Icons.star_border),
            title: Text('Important'),
          ),
          ListTile(
            leading: Icon(Icons.send),
            title: Text('Sent'),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Trash'),
          ),
          Divider(),
          ListTile(
            leading: Text('GOOGLE APPS'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Contact'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Feedback'),
          ),
        ],
      ),
    );
  }
}
