import 'package:flutter/material.dart';
import 'task_model.dart';
import 'dart:async';
import 'package:flutter_application_1/component/drawer.dart';


class ToDoHomePage extends StatefulWidget {
  const ToDoHomePage({super.key});

  @override
  _ToDoHomePageState createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  final List<Task> _tasks = [];
  final List<Task> _completedTasks = [];
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String _selectedPriority = 'Low';
  Timer? _timer;
  Duration _remainingTime = Duration.zero;

  void _addTask() {
    final taskTitle = _taskController.text.trim();
    final durationInMinutes = int.tryParse(_timeController.text) ?? 0;

    if (taskTitle.isNotEmpty && durationInMinutes > 0) {
      final task = Task(
        title: taskTitle,
        priority: _selectedPriority,
        duration: Duration(minutes: durationInMinutes),
      );

      setState(() {
        _tasks.add(task);
      });

      _taskController.clear();
      _timeController.clear();
    }
  }

  void _startTask(Task task) {
    if (_timer != null) {
      _timer!.cancel();
    }

    setState(() {
      task.isRunning = true;
      _remainingTime = task.duration;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds <= 0) {
        timer.cancel();
        setState(() {
          _completedTasks.add(task);
          _tasks.remove(task);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${task.title} completed and deleted!')),
        );
      } else {
        setState(() {
          _remainingTime -= const Duration(seconds: 1);
        });
      }
    });
  }

  void _stopTask(Task task) {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      task.isRunning = false;
    });
  }

  void _editTask(Task task) {
    final TextEditingController editTitleController =
        TextEditingController(text: task.title);
    final TextEditingController editTimeController =
        TextEditingController(text: task.duration.inMinutes.toString());
    String selectedPriority = task.priority;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editTitleController,
                decoration: const InputDecoration(
                  hintText: 'Task title',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: editTimeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Duration (mins)',
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedPriority,
                underline: Container(),
                items: ['Low', 'Medium', 'High']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedPriority = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                print('save button pressed');
                final newTitle = editTitleController.text.trim();
                final newDuration = int.tryParse(editTimeController.text) ?? 0;

                if (newTitle.isNotEmpty && newDuration > 0) {
                  setState(() {
                    final index = _tasks.indexOf(task);
                    if (index != -1) {
                      _tasks[index] = Task(
                        title: newTitle,
                        duration: Duration(minutes: newDuration),
                        priority: selectedPriority,
                      );
                    }
                    print('updated task:$_tasks');
                  });
                  Navigator.pop(context); // Close the dialog
                } else {
                  print('Invalid input');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid details')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'To-Do',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      drawer:  MyDrawer(completedTasks: _completedTasks,),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildInputFields(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildTaskList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: 'Task',
              hintStyle: TextStyle(fontWeight: FontWeight.bold),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: TextField(
            controller: _timeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Time',
              hintStyle: TextStyle(fontWeight: FontWeight.bold),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: _selectedPriority,
          underline: Container(),
          items: ['Low', 'Medium', 'High']
              .map((priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedPriority = value!;
            });
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: _addTask,
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          color: Colors.grey[100],
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(
              task.title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              task.isRunning
                  ? '${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')} min'
                  : '${task.duration.inMinutes}min',
              style: const TextStyle(
                color: Colors.black, // Explicitly set subtitle color
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () => _editTask(task),
                ),
                task.isRunning
                    ? IconButton(
                        icon: const Icon(Icons.stop, color: Colors.red),
                        onPressed: () => _stopTask(task),
                      )
                    : IconButton(
                        icon: const Icon(Icons.play_arrow, color: Colors.black),
                        onPressed: () => _startTask(task),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
