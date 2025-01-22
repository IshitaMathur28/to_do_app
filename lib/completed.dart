import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/task_model.dart';

class Completed extends StatelessWidget {
  final List<Task> completedTasks;
  const Completed({super.key, required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Tasks'),
      ),
      body: completedTasks.isEmpty ?
      const Center(
        child: Text(
          'No completed tasks yet!',
          style: TextStyle(
            fontSize: 16,fontWeight: FontWeight.bold
          ),
        ),
      )
      : ListView.builder(
        itemCount:completedTasks.length,
        itemBuilder: (context, index) {
          final task= completedTasks[index];
          return Card(
            color: Colors.grey,
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(task.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              ),
              subtitle: const Text(
                'Completed',
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
