import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/component/drawer_tile.dart';
import 'package:flutter_application_1/model/task_model.dart';
import 'package:flutter_application_1/settings.dart';
import 'package:flutter_application_1/completed.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key,required this.completedTasks});
  final List<Task> completedTasks;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          //header
          const DrawerHeader(
            child: Icon(Icons.note),
          ),

          //notes tile
          DrawerTile(
            title: 'Tasks',
            leading: const Icon(Icons.home),
            onTap: () => Navigator.pop(context),
          ),

          //setting tile
          DrawerTile(
            title: 'Settings',
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
          ),

          DrawerTile(
            title: 'Completed',
            leading: const Icon(Icons.check_box),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Completed(completedTasks: completedTasks),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
