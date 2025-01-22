class Task {
  late final String title;
  late final String priority;
  late final Duration duration;
  bool isRunning;

  Task({
    required this.title,
    required this.priority,
    required this.duration,
    this.isRunning = false,
  });
}